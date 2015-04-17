angular.module('starter')

.controller 'TopicCtrl', (
  toast
  $scope
  $state
  $timeout
  $ionicModal
  authService
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
    isCollected: false
    error: null
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
      authService
        .isAuthenticated()
        .then ->
          userService.collectTopic topic
            .then ->
              $scope.isCollected = true
              toast '收藏成功'

    deCollectTopic: (topic) ->
      authService
        .isAuthenticated()
        .then ->
          userService.deCollectTopic topic
            .then ->
              $scope.isCollected = false
              toast '已取消收藏'

    replyTopic: ->
      authService
        .isAuthenticated()
        .then ->
          $state.go 'app.replies', topicId:$stateParams.topicId

    myCollect: ->
      authService
        .isAuthenticated()
        .then (me) ->
          $state.go 'app.user', loginname:me.loginname


  $scope.loadTopic()
  userService.checkCollect $stateParams.topicId
    .then (isCollected) ->
      $scope.isCollected = isCollected

