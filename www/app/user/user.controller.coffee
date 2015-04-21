angular.module('ionic-nodeclub')

.controller 'UserCtrl', (
  $scope
  userService
  $stateParams
  messageService
) ->

  userService.getDetail($stateParams.loginname, true)
    .then (user) ->
      $scope.user = user
      $scope.displayType =
        if $scope.isCollectVisible()
          'collect_topics'
        else
          'recent_topics'
      console.log 'user', $scope.user

  angular.extend $scope,
    user: null
    displayType: null
    $stateParams: $stateParams
    messageService: messageService

    isCollectVisible: ->
      isMyDetail = $scope.user and $scope.me?.loginname is $scope.user?.loginname
      hasCollectedTopics = $scope.user?.collect_topics.length
      isMyDetail or hasCollectedTopics

    changeType: (type) ->
      $scope.displayType = type

