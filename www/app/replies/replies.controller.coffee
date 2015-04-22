angular.module('ionic-nodeclub')

.controller 'RepliesCtrl', (
  focus
  toast
  $scope
  $state
  $filter
  $window
  authService
  $ionicModal
  $stateParams
  topicService
  $ionicLoading
  $cordovaClipboard
  $ionicActionSheet
  $ionicScrollDelegate
) ->

  $ionicModal
    .fromTemplateUrl('app/replies/reply-preview-modal.html', scope: $scope)
    .then (modal) ->
      $scope.replyModal = modal

  loadReplies = (refresh) ->
    $scope.loading = true
    topicService.getReplies($stateParams.topicId, refresh)
      .then (topic) ->
        $scope.topic = topic
        $scope.displayReplies = topic.replies.slice(0, 30)
      .catch (error) ->
        $scope.error = error
      .finally ->
        $scope.loading = false
        $scope.$broadcast('scroll.refreshComplete')

  angular.extend $scope,
    loading: false
    error: null
    topic: null
    displayReplies: null
    replyModal: null
    scrollDelegate: $ionicScrollDelegate.$getByHandle('replies-handle')
    newReply:
      content: ''

    doRefresh: ->
      if $scope.loading then return
      $scope.error = null
      loadReplies(refresh = true)

    displayAll: ->
      $scope.displayReplies = $scope.topic.replies

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
              text = $filter('toMarkdown')(reply.content)
              if $window.cordova
                $cordovaClipboard
                  .copy text
                  .then ->
                    toast '已拷贝到粘贴板'
              else
                console.log 'copy...' + text
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
            when 0 then $scope.sendReply()
            when 1 then $scope.replyModal.show()
            else        $scope.clearNewReply()
          return true

  $scope.doRefresh()
