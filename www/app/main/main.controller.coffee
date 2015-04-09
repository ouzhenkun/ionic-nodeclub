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
      $ionicLoading.show()
      Restangular
        .all('accessToken')
        .post(accesstoken: accessToken)
        .then (user) ->
          storage.set 'user', user
          storage.set 'accessToken', accessToken
          console.log 'login success', user
        .catch (error) ->
          console.log 'login error', error
        .finally ->
          $ionicLoading.hide()

