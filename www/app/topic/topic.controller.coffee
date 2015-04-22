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

  angular.extend $scope,
    loading: false
    isCollected: false
    error: null
    topic: null

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
          if $scope.isCollected
            userService.deCollectTopic topic
              .then ->
                $scope.isCollected = false
                toast '已取消收藏'
          else
            userService.collectTopic topic
              .then ->
                $scope.isCollected = true
                toast '收藏成功'

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

    showTopicAction: ->
      $ionicActionSheet.show
        buttons: [
          text: '重新加载'
        ,
          text: '回复话题'
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
              $scope.loadTopic(true)
            when 1
              $scope.replyTopic()
            when 2
              $scope.collectTopic()
            when 3
              $state.go 'app.user', loginname: $scope.topic.author.loginname
            else
              window.open "#{API.server}/topic/#{$stateParams.topicId}", '_system'
          return true



  $scope.loadTopic()
  userService.checkCollect $stateParams.topicId
    .then (isCollected) ->
      $scope.isCollected = isCollected

