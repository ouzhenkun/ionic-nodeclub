angular.module('starter')

.controller 'TopicCtrl', (
  $scope
  $timeout
  Restangular
  $stateParams
  userService
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
    reload: ->
      $scope.loading = true
      Restangular
        .one('topic', $stateParams.topicId)
        .get()
        .then (result) ->
          $scope.topic = result?.data
        .catch (error) ->
          $scope.error = error
          $scope.topic = null
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

  $scope.reload()
  userService.hasCollect $stateParams.topicId
    .then (collected) ->
      $scope.collected = collected

