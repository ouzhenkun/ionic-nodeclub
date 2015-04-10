angular.module('starter')

.controller 'UserCtrl', ($scope, $stateParams, Restangular) ->

  Restangular
    .one('user', $stateParams.loginname)
    .get()
    .then (result) ->
      $scope.user = result?.data
      $scope.topicType =
        if $scope.showCollect()
          'collect_topics'
        else
          'recent_topics'
      console.log 'user', $scope.user

  angular.extend $scope,
    $stateParams: $stateParams
    showCollect: ->
      $scope.user and (
        $scope.me?.loginname is $scope.user?.loginname or
        $scope.user?.collect_topics.length
      )
    user: null
    topicType: null
    changeType: (type) ->
      $scope.topicType = type

