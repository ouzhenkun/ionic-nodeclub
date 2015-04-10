angular.module('starter')

.controller 'RepliesCtrl', ($scope, $ionicModal, $stateParams, Restangular) ->

  Restangular
    .one('topic', $stateParams.topicId)
    .get()
    .then (result) ->
      $scope.replies = result?.data?.replies

  angular.extend $scope,
    replies: null

