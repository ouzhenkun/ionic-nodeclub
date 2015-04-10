angular.module('starter')

.controller 'UserCtrl', (
  $scope
  userService
  $stateParams
) ->

  userService.get($stateParams.loginname, true)
    .then (user) ->
      $scope.user = user
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

