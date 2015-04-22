angular.module('ionic-nodeclub')

.factory 'authService', (
  $q
  toast
  storage
  $window
  $timeout
  $rootScope
  Restangular
  $ionicModal
  $ionicLoading
  $cordovaBarcodeScanner
) ->

  #
  # 我是控制 login-modal 的代码
  #

  $scope = $rootScope.$new()

  angular.extend $scope,
    loginModal: null
    canScan: $window.cordova

    doLogin: (token) ->
      checkToken token
        .then (user) ->
          toast '登录成功，欢迎您: ' + user.loginname
          $scope.loginModal?.hide()
        , (error) ->
          toast '登录失败: ' + error?.data?.error_msg

    doScan: ->
      # FIXME 屏幕旋转，login-modal 界面显示有点乱
      $cordovaBarcodeScanner
        .scan()
        .then (imageData) =>
          $scope.loginModal?.hide()
          toast '扫码成功，正在登录...'
          @doLogin(imageData.text)
        , (error) ->
          toast '扫码错误 ' + error

  $ionicModal
    .fromTemplateUrl('app/main/login-modal.html', scope: $scope)
    .then (modal) ->
      $scope.loginModal = modal

  $scope.$on '$destroy', ->
    $scope.loginModal?.remove()

  #
  # 我在authService初始化的时候会用到
  #

  checkToken = (token) ->
    $q (resolve, reject) ->
      $ionicLoading.show()
      Restangular
        .all('accessToken')
        .post(accesstoken: token)
        .then (user) ->
          $ionicLoading.hide()
          storage.set 'user', angular.extend(user, token: token)
          $rootScope.$broadcast 'auth.userUpdated', user
          resolve user
        , (error) ->
          $ionicLoading.hide()
          reject(error)

  #
  # 我要在初始化的时候检查localStorage的token是否合法
  # 不合法我就删除localStorage里的user
  #
  if tokenToInit = storage.get('user')?.token
    checkToken(tokenToInit)
      .catch (error) ->
        console.log 'login error=' + error
        storage.remove 'user'
        toast '登录失败: ' + error?.data?.error_msg

  #
  # TODO 楼上的看起来有点乱，我要找时间重构一下
  #

  #
  # public method
  #
  login: ->
    $scope.loginModal?.show()

  logout: ->
    storage.remove 'user'
    $rootScope.$broadcast 'auth.userLogout'
    toast '您已登出'

  # 我要确保有些操作是用户已经登录了的
  isAuthenticated: ->
    $q (resolve, reject) =>
      user = storage.get 'user'
      if user?.token
        resolve(user)
      else
        toast '请先登录', 1500
        $timeout @login, 500
        reject()

