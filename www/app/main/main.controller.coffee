angular.module('starter')

.controller 'MainCtrl', (
  tabs
  toast
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
      $ionicLoading.show()
      userService.login(token)
        .then (user) ->
          $scope.me = user
          $scope.loginModal?.hide()
          toast '登录成功，欢迎您: ' + user.loginname
        .catch (error) ->
          toast '登录失败: ' + error?.data?.error_msg
        .finally $ionicLoading.hide

    doLogout: ->
      userService.logout()
      $scope.me = null
      toast '您已登出'

