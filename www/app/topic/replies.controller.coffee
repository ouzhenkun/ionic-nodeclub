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

  $ionicModal
    .fromTemplateUrl('app/topic/reply-preview-modal.html', scope: $scope)
    .then (modal) ->
      $scope.replyModal = modal

  angular.extend $scope,
    loading: false
    error: null
    replies: null
    replyModal: null
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
      content = $scope.newReply.content
      content += " @#{author.loginname}"
      $scope.newReply.content = content.trim() + ' '
      focus('focus.newReplyInput')
    showReplyAction: (reply) ->
      $ionicActionSheet.show
        buttons: [
          text: '复制'
        ,
          text: '引用'
        ,
          text: '作者'
        ]
        buttonClicked: (index) ->
          switch index
            when 0
              console.log 'copy...', $filter('toMarkdown')(reply.content)
            when 1
              quote = $filter('toMarkdown')(reply.content)
              quote = '\n' + quote.trim().replace(/([^\n]+)\n*/g, '>$1\n>\n')
              content = $scope.newReply.content + "#{quote}"
              $scope.newReply.content = content.trim() + '\n\n'
              focus('focus.newReplyInput')
            else
              $state.go('app.user', loginname:reply.author.loginname)
          return true
    sendReply: ->
      console.log 'sendReply', $scope.newReply
    showSendAction: ->
      $ionicActionSheet.show
        buttons: [
          text: '发送'
        ,
          text: '预览'
        ,
          text: '清除'
        ]
        buttonClicked: (index) ->
          switch index
            when 0
              $scope.sendReply()
            when 1
              $scope.replyModal.show()
            else
              $scope.newReply.content = ''
              focus('focus.newReplyInput')
          return true

  loadReplies()
