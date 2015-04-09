angular.module('starter')

.controller 'MainCtrl', (
  tabs
  $scope
  $state
  storage
  Restangular
  $ionicModal
  $ionicLoading
) ->

  $ionicModal
    .fromTemplateUrl('app/main/login-modal.html', scope: $scope)
    .then (modal) ->
      $scope.loginModal = modal

  # Export Properties
  angular.extend $scope,
    me: storage.get 'user'
    tabs: tabs
    loginModal: null
    showLogin: ->
      $scope.loginModal.show()
    closeLogin: ->
      $scope.loginModal.hide()
    doLogin: (token) ->
      $ionicLoading.show(template: '登录中...')
      Restangular
        .all('accessToken')
        .post(accesstoken: token)
        .then (user) ->
          user.token = token
          $scope.me = user
          storage.set 'user', user
          console.log 'login success', user
          $scope.closeLogin()
          $ionicLoading.show(template: '登录成功，欢迎您: ' + user?.loginname, duration: 1000)
        .catch (error) ->
          console.log 'login error', error
          $ionicLoading.show(template: '登录失败: ' + error?.data?.error_msg, duration: 1000)
    doLogout: ->
      #storage.remove 'user'
      $scope.me = null
      $ionicLoading.show(template: '您已登出', duration: 1000)

  console.log 'me', $scope.me
