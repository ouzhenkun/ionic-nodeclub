angular.module('starter')

.controller 'TopicCtrl', (
  $scope
  $timeout
  $ionicModal
  userService
  topicService
  $stateParams
  $ionicPopover
  $ionicLoading
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
          $ionicLoading.show
            template: '收藏成功',
            duration: 1000
            noBackdrop: true
    deCollectTopic: (topic) ->
      userService.deCollectTopic topic
        .then ->
          $scope.collected = false

  $scope.loadTopic()
  userService.checkCollect $stateParams.topicId
    .then (collected) ->
      $scope.collected = collected

