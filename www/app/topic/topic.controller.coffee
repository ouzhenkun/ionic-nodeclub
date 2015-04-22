angular.module('ionic-nodeclub')

.controller 'TopicCtrl', (
  API
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
  $ionicActionSheet
) ->

  collectTopic = ->
    authService
      .isAuthenticated()
      .then ->
        if $scope.isCollected
          userService.deCollectTopic $scope.topic
            .then ->
              $scope.isCollected = false
              toast '已取消收藏'
        else
          userService.collectTopic $scope.topic
            .then ->
              $scope.isCollected = true
              toast '收藏成功'

  loadTopic = (refresh) ->
    $scope.loading = true
    topicService.getDetail $stateParams.topicId, refresh
      .then (topic) ->
        $scope.topic = topic
      .catch (error) ->
        $scope.error = error
      .finally ->
        $scope.loading = false
        $scope.$broadcast('scroll.refreshComplete')

  angular.extend $scope,
    loading: false
    isCollected: false
    error: null
    topic: null

    doRefresh: ->
      loadTopic(refresh = true)

    showTopicAction: ->
      $ionicActionSheet.show
        buttons: [
          text: '话题回复'
        ,
          text: if !$scope.isCollected then '收藏话题' else '取消收藏'
        ,
          text: '关于作者'
        ,
          text: '浏览器打开'
        ]
        buttonClicked: (index) ->
          switch index
            when 0
              $state.go 'app.replies', topicId:$stateParams.topicId
            when 1
              collectTopic()
            when 2
              $state.go 'app.user', loginname: $scope.topic.author.loginname
            else
              window.open "#{API.server}/topic/#{$stateParams.topicId}", '_system'
          return true


  loadTopic(refresh = false)
  userService.checkCollect $stateParams.topicId
    .then (isCollected) ->
      $scope.isCollected = isCollected

