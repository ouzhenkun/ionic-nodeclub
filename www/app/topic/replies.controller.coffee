angular.module('starter')

.controller 'RepliesCtrl', (
  focus
  $scope
  $state
  $filter
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
    newReply:
      content: ''
    toggleLike: (reply) ->
      topicService.toggleLikeReply(reply)
        .then (action) ->
          if action isnt 'up' then return
          $ionicLoading.show
            template: '已赞'
            duration: 1000
            noBackdrop: true
    replyAuthor: (author) ->
      $scope.newReply.content = "@#{author.loginname} "
      focus('focus.newReplyInput')
    showAction: (reply) ->
      $ionicActionSheet.show
        buttons: [
          text: '@' + reply.author.loginname
        ,
          text: '引用内容'
        ,
          text: '用户信息'
        ]
        buttonClicked: (index) ->
          switch index
            when 0
              $scope.newReply.content += " @#{reply.author.loginname} "
              focus('focus.newReplyInput')
            when 1
              $scope.newReply.content += "> #{$filter('toMarkdown')(reply.content)}\n\n"
              focus('focus.newReplyInput')
            else
              $state.go('app.user', loginname:reply.author.loginname)
          return true

  loadReplies()
