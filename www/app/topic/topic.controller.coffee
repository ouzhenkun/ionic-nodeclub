angular.module('starter')

.controller 'TopicCtrl', (
  $scope
  $timeout
  userService
  topicService
  $stateParams
  $ionicPopover
) ->

  $ionicPopover.fromTemplateUrl 'app/topic/topic-popover.html',
    scope: $scope
  .then (popover) ->
    $scope.popover = popover

  angular.extend $scope,
    loading: false
    error: null
    collected: false
    topic: null
    popover: null
    hidePopover: (event) ->
      $timeout ->
        $scope.popover.hide(event)
      , 100
    loadTopic: (reload = false) ->
      $scope.loading = true
      topicService.getDetail $stateParams.topicId, reload
        .then (topic) ->
          $scope.topic = topic
        .catch (error) ->
          $scope.error = error
        .finally ->
          $scope.loading = false
    collectTopic: (topic) ->
      userService.collectTopic topic
        .then ->
          $scope.collected = true
    deCollectTopic: (topic) ->
      userService.deCollectTopic topic
        .then ->
          $scope.collected = false
    replyTopic: (topic) ->
      console.log 'replyTopic', $scope.me, topic

  $scope.loadTopic()
  userService.hasCollect $stateParams.topicId
    .then (collected) ->
      $scope.collected = collected

