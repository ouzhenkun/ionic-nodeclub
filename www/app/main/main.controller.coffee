angular.module('starter')

.controller 'MainCtrl', (
  tabs
  $scope
  $state
  storage
  userService
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
    doLogin: (token) ->
      $ionicLoading.show(template: '登录中...')
      userService.login(token)
        .then (user) ->
          $scope.me = user
          $scope.loginModal?.hide()
          $ionicLoading.show
            template: '登录成功，欢迎您: ' + user.loginname
            duration: 1000
            noBackdrop: true
        .catch (error) ->
          $ionicLoading.show
            template: '登录失败: ' + error?.data?.error_msg
            duration: 1000
            noBackdrop: true
    doLogout: ->
      userService.logout()
      $scope.me = null
      $ionicLoading.show
        template: '您已登出',
        duration: 1000
        noBackdrop: true

