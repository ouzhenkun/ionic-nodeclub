angular.module('starter')

.controller 'MainCtrl', ($scope, tabs, $ionicModal) ->

  $ionicModal
    .fromTemplateUrl('app/main/login-modal.html', scope: $scope)
    .then (modal) ->
      $scope.loginModal = modal

  # Export Properties
  angular.extend $scope,
    tabs: tabs
    loginModal: null
    showLogin: ->
      $scope.loginModal.show()
    closeLogin: ->
      $scope.loginModal.hide()

