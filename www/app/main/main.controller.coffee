angular.module('starter')

.controller 'MainCtrl', (
  tabs
  $scope
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
    tabs: tabs
    loginModal: null
    loginData: {}
    showLogin: ->
      $scope.loginModal.show()
    closeLogin: ->
      $scope.loginModal.hide()
    doLogin: (accessToken) ->
      $ionicLoading.show(template: '登录中...')
      Restangular
        .all('accessToken')
        .post(accesstoken: accessToken)
        .then (user) ->
          storage.set 'user', user
          storage.set 'accessToken', accessToken
          console.log 'login success', user
          $scope.closeLogin()
          $ionicLoading.show(template: '登录成功，欢迎您: ' + user?.loginname, duration: 1000)
        .catch (error) ->
          console.log 'login error', error
          $ionicLoading.show(template: '登录失败: ' + error?.data?.error_msg, duration: 1000)

