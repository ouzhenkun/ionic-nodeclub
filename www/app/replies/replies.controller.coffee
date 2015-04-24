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

  updateHotReplies = ->
    if $scope.allReplies.length > 10
      hotReplies = _.filter $scope.allReplies, (reply) ->
        reply.ups.length > 0
      if hotReplies.length > 0
        hotReplies = hotReplies.sort (a, b) ->
          b.ups.length - a.ups.length
        $scope.hotReplies = hotReplies.slice(0, 5)

  loadReplies = (refresh) ->
    $scope.loading = true
    topicService.getReplies($stateParams.topicId, refresh)
      .then (topic) ->
        $scope.topic = topic
        $scope.allReplies = topic.replies.reverse()
        $scope.displayReplies = $scope.allReplies.slice(0, 30)
        updateHotReplies()
      .catch (error) ->
        $scope.error = error
      .finally ->
        $scope.loading = false
        $scope.$broadcast('scroll.refreshComplete')

  angular.extend $scope,
    loading: false
    error: null
    topic: null
    replyModal: null
    hotReplies: null
    allReplies: null
    displayReplies: null
    scrollDelegate: $ionicScrollDelegate.$getByHandle('replies-handle')
    newReply:
      content: ''

    doRefresh: ->
      if $scope.loading then return
      $scope.scrollDelegate.scrollTop(true)
      $scope.error = null
      loadReplies(refresh = true)

    displayAll: ->
      $scope.displayReplies = $scope.allReplies

    toggleLike: (reply) ->
      authService.withAuthUser (authUser) ->
        topicService.toggleLikeReply(reply, authUser)
          .then (action) ->
            toast '已赞' if action is 'up'

    replyAuthor: (reply) ->
      authService.withAuthUser (authUser) ->
        $scope.newReply.content = "@#{reply.author.loginname} "
        $scope.newReply.reply_id = reply.id
        focus('focus.newReplyInput')

    clearNewReply: ->
      $scope.newReply.content = ''
      $scope.newReply.reply_id = null

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
            # copy content
            when 0
              text = $filter('toMarkdown')(reply.content)
              if $window.cordova
                $cordovaClipboard
                  .copy text
                  .then ->
                    toast '已拷贝到粘贴板'
              else
                console.log 'copy...' + text
            # quote content
            when 1
              quote = $filter('toMarkdown')(reply.content)
              quote = '\n' + quote.trim().replace(/([^\n]+)\n*/g, '>$1\n>\n')
              content = $scope.newReply.content + "#{quote}"
              $scope.newReply.content = content.trim() + '\n\n'
              focus('focus.newReplyInput')
            # @ someone
            when 2
              content = $scope.newReply.content
              content += " @#{reply.author.loginname}"
              $scope.newReply.content = content.trim() + ' '
              focus('focus.newReplyInput')
            # about author
            else
              $state.go('app.user', loginname: reply.author.loginname)
          return true

    sendReply: ->
      authService.withAuthUser (authUser) ->
        $ionicLoading.show()
        topicService.sendReply($stateParams.topicId, $scope.newReply, authUser)
          .then $scope.clearNewReply
          .finally $ionicLoading.hide

    showSendAction: ->
      $ionicActionSheet.show
        buttons: [
          text: '发送'
        ,
          text: '预览'
        ]
        buttonClicked: (index) ->
          switch index
            when 0
              $scope.sendReply()
            else
              if $scope.replyModal?
                $scope.replyModal.show()
              else
                $ionicLoading.show()
                $ionicModal
                  .fromTemplateUrl('app/replies/reply-preview-modal.html', scope: $scope)
                  .then (modal) ->
                    $scope.replyModal = modal
                    $scope.replyModal.show()
                  .finally ->
                    $ionicLoading.hide()
          return true

  loadReplies(refresh = true)

  $scope.$on '$destroy', ->
    $scope.replyModal?.remove()

