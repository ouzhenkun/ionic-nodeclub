angular.module('starter')

.controller 'RepliesCtrl', (
  focus
  toast
  $scope
  $state
  $filter
  $ionicModal
  $stateParams
  topicService
  $ionicLoading
  $ionicActionSheet
  $ionicScrollDelegate
) ->

  loadReplies = (reloadForNewReply = false) ->
    $scope.loading = true
    topicService.getReplies $stateParams.topicId, reloadForNewReply
      .then (replies) ->
        $scope.replies = replies
        if reloadForNewReply
          $scope.scrollDelegate.scrollBottom(true)
      .catch (error) ->
        $scope.error = error
      .finally ->
        $scope.loading = false


  $ionicModal
    .fromTemplateUrl('app/replies/reply-preview-modal.html', scope: $scope)
    .then (modal) ->
      $scope.replyModal = modal

  angular.extend $scope,
    loading: false
    error: null
    replies: null
    replyModal: null
    scrollDelegate: $ionicScrollDelegate.$getByHandle('replies-handle')
    newReply:
      content: ''

    toggleLike: (reply) ->
      topicService.toggleLikeReply(reply)
        .then (action) ->
          if action isnt 'up' then return
          toast '已赞'

    replyAuthor: (reply) ->
      $scope.newReply.content = "@#{reply.author.loginname} "
      $scope.newReply.reply_id = reply.id
      focus('focus.newReplyInput')

    clearNewReply: ->
      $scope.newReply.content = ''
      $scope.newReply.reply_id = null
      focus('focus.newReplyInput')

    showReplyAction: (reply) ->
      $ionicActionSheet.show
        buttons: [
          text: '复制'
        ,
          text: '引用'
        ,
          text: '@Ta'
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
            when 2
              content = $scope.newReply.content
              content += " @#{reply.author.loginname}"
              $scope.newReply.content = content.trim() + ' '
              focus('focus.newReplyInput')
            else
              $state.go('app.user', loginname:reply.author.loginname)
          return true

    sendReply: ->
      $ionicLoading.show()
      topicService.sendReply $stateParams.topicId, $scope.newReply
        .then ->
          $scope.clearNewReply()
          loadReplies(true)
        .finally $ionicLoading.hide

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
              $scope.clearNewReply()
          return true

  loadReplies()
