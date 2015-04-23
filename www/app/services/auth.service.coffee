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

  # 我定义一个'重新获取authUser'的方法
  # 让之后的Login可以调用
  reloadAuthUser = (token) ->
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

  # 我创建一个scope以便之后让login-modal调用
  mkLoginModalScope = ->
    angular.extend $rootScope.$new(),
      loginModal: null
      canScan: $window.cordova?

      doLogin: (token) ->
        reloadAuthUser(token)
          .then (user) =>
            toast '登录成功，欢迎您: ' + user.loginname
            @loginModal?.hide()
          , (error) ->
            toast '登录失败: ' + error?.data?.error_msg

      doScan: ->
        # FIXME 屏幕旋转，login-modal 界面显示有点乱
        $cordovaBarcodeScanner
          .scan()
          .then (imageData) =>
            @loginModal?.hide()
            toast '扫码成功，正在登录...'
            @doLogin(imageData.text)
          , (error) ->
            toast '扫码错误 ' + error

  # 创建一个新的scope
  scope = mkLoginModalScope()

  # 初始化loginModal
  $ionicModal
    .fromTemplateUrl('app/main/login-modal.html', scope: scope)
    .then (modal) ->
      scope.loginModal = modal

  # scope销毁的时候移除loginModal
  scope.$on '$destroy', ->
    console.log 'remove login modal'
    scope.loginModal?.remove()

  # 我在authService初始化的时候，检查storage里的token是否合法
  if initedToken = storage.get('user')?.token
    reloadAuthUser(initedToken)
      .catch (error) ->
        console.log 'login error=' + error
        storage.remove 'user'
        toast '登录失败: ' + error?.data?.error_msg

  #
  # service methods
  #
  return {

    login: ->
      scope.loginModal.show()

    logout: ->
      storage.remove 'user'
      $rootScope.$broadcast 'auth.userLogout'
      toast '您已登出'

    # 检索authUser并执行next
    # 如果检索不到，弹出登录框
    withAuthUser: (next) ->
      user = storage.get 'user'
      if user?.token
        next(user)
      else
        toast '请先登录', 1500
        $timeout @login, 500
  }

