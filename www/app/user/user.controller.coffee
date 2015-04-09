angular.module('starter')

.controller 'UserCtrl', ($scope, $stateParams, Restangular) ->

  Restangular
    .one('user', $stateParams.loginname)
    .get()
    .then (result) ->
      $scope.user = result?.data
      console.log 'user', $scope.user

  angular.extend $scope,
    $stateParams: $stateParams
    user: null

