angular.module('starter')

.controller 'RepliesCtrl', (
  focus
  toast
  $scope
  $state
  $filter
  authService
  $ionicModal
  $stateParams
  topicService
  $ionicLoading
  $ionicActionSheet
  $ionicScrollDelegate
) ->

  loadReplies = (refresh) ->
    $scope.loading = true
    from = if refresh then 0 else $scope.replies.length
    topicService.getReplies($stateParams.topicId, from, refresh)
      .then (resp) ->
        if refresh
          $scope.replies.length = 0
        $scope.replies = $scope.replies.concat(resp.replies)
        $scope.hasMore = resp.hasMore
        $scope.nTotal = resp.nTotal
      .catch (error) ->
        $scope.error = error
      .finally ->
        $scope.loading = false
        $scope.$broadcast('scroll.refreshComplete')
        $scope.$broadcast('scroll.infiniteScrollComplete')


  $ionicModal
    .fromTemplateUrl('app/replies/reply-preview-modal.html', scope: $scope)
    .then (modal) ->
      $scope.replyModal = modal

  angular.extend $scope,
    loading: false
    error: null
    replies: []
    hasMore: true
    nTotal: 0
    replyModal: null
    scrollDelegate: $ionicScrollDelegate.$getByHandle('replies-handle')
    newReply:
      content: ''

    doRefresh: ->
      if $scope.loading then return
      $scope.error = null
      $scope.hasMore = true
      loadReplies(refresh = true)

    loadMore: ->
      if $scope.loading or $scope.error then return
      loadReplies(refresh = false)

    toggleLike: (reply) ->
      authService
        .isAuthenticated()
        .then ->
          topicService.toggleLikeReply(reply)
            .then (action) ->
              toast '已赞' if action is 'up'

    replyAuthor: (reply) ->
      authService
        .isAuthenticated()
        .then ->
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
      authService
        .isAuthenticated()
        .then ->
          $ionicLoading.show()
          topicService.sendReply($stateParams.topicId, $scope.newReply)
            .then $scope.clearNewReply
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

