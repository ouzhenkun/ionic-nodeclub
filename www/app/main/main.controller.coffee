angular.module('starter')

.controller 'MainCtrl', (
  tabs
  $scope
  $state
  storage
  userService
  $ionicModal
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
      userService.login(token)
        .then (user) ->
          $scope.me = user
          $scope.loginModal?.hide()
    doLogout: ->
      userService.logout()
        .then ->
          $scope.me = null

  console.log 'me', $scope.me
