angular.module('starter')

.controller 'RepliesCtrl', (
  $scope
  $state
  $ionicModal
  $stateParams
  topicService
  $ionicLoading
  $ionicActionSheet
) ->

  loadReplies = (reload = false) ->
    $scope.loading = true
    topicService.getReplies $stateParams.topicId, reload
      .then (replies) ->
        $scope.replies = replies
      .catch (error) ->
        $scope.error = error
      .finally ->
        $scope.loading = false


  angular.extend $scope,
    loading: false
    error: null
    replies: null
    toggleLike: (reply) ->
      topicService.toggleLikeReply(reply)
        .then (action) ->
          if action isnt 'up' then return
          $ionicLoading.show
            template: '已赞'
            duration: 1000
            noBackdrop: true
    showAction: (reply) ->
      $ionicActionSheet.show
        buttons: [
          text: '@' + reply.author.loginname
        ,
          text: '复制'
        ,
          text: '关于'
        ]
        buttonClicked: (index) ->
          switch index
            when 0
              console.log '@' + reply.author.loginname
            when 1
              console.log '复制'
            else
              $state.go('app.user', loginname:reply.author.loginname)
          return true

  loadReplies()
