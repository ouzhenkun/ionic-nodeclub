angular.module('ionic-nodeclub')

.factory 'authService', (
  $q
  API
  toast
  storage
  $window
  $timeout
  $rootScope
  Restangular
  $ionicModal
  $ionicLoading
  $ionicPlatform
  $cordovaClipboard
  IONIC_BACK_PRIORITY
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
      API: API
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

        # 我在这里覆盖'点返回按钮关闭modal'的逻辑
        # 为了修复扫码的时候按了返回按钮把loginModal关掉的BUG
        deregisterBackButton = $ionicPlatform
          .registerBackButtonAction angular.noop, IONIC_BACK_PRIORITY.modal + 1

        # 开始扫码
        $cordovaBarcodeScanner
          .scan()
          .then (result) =>
            if !result.cancelled
              @doLogin(result.text)
          , (error) ->
            toast '扫码错误 ' + error
          .finally ->
            # 我在去掉上面的‘点返回按钮关闭modal’的覆盖
            $timeout deregisterBackButton, 500

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
        toast '请先登录'
        $timeout @login, 500
  }

