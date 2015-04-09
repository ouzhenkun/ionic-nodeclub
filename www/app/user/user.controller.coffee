angular.module('starter')

.controller 'UserCtrl', ($scope, $stateParams, Restangular) ->

  Restangular
    .one('user', $stateParams.loginname)
    .get()
    .then (result) ->
      $scope.user = result?.data
      $scope.topicType =
        if $scope.user.collect_topics.length
          'collect_topics'
        else
          'recent_topics'
      console.log 'user', $scope.user

  angular.extend $scope,
    $stateParams: $stateParams
    user: null
    topicType: null
    changeType: (type) ->
      $scope.topicType = type

