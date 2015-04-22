angular.module('ionic-nodeclub')

.controller 'TopicsCtrl', (
  tabs
  toast
  $scope
  $timeout
  authService
  $ionicModal
  $stateParams
  $ionicPopover
  topicService
  $ionicScrollDelegate
) ->

  $ionicModal
    .fromTemplateUrl 'app/topics/new-topic-modal.html',
      scope: $scope
    .then (modal) ->
      $scope.newTopicModal = modal

  selectedTab = $stateParams.tab ? tabs[0].value

  loadTopics = (refresh) ->
    $scope.loading = true
    from = if refresh then 0 else $scope.topics.length
    topicService.getTopics selectedTab, from
      .then (resp) ->
        if refresh
          $scope.topics.length = 0
        $scope.topics = $scope.topics.concat(resp.topics)
        $scope.hasMore = resp.hasMore
      .catch (error) ->
        $scope.error = error
      .finally ->
        $scope.loading = false
        $scope.$broadcast('scroll.refreshComplete')
        $scope.$broadcast('scroll.infiniteScrollComplete')

  mkNewTopic = ->
    tab: selectedTab
    content: ''
    title: ''

  # Export Properties
  angular.extend $scope,
    newTopicModal: null
    hasMore: true
    scrollDelegate: $ionicScrollDelegate.$getByHandle('topics-handle')
    loading: false
    error: null
    selectedTab: selectedTab
    topics: []
    tabs: _.filter(tabs, (t) -> t.value isnt 'all')
    newTopic: mkNewTopic()

    createNewTopic: ->
      authService
        .isAuthenticated()
        .then ->
          $scope.newTopicModal.show()

    doPostTopic: ->
      return toast('发布失败：请先选择一个板块。', 2000) if _.isEmpty($scope.newTopic.tab)
      return toast('发布失败：请先输入标题。'    , 2000) if _.isEmpty($scope.newTopic.title)
      return toast('发布失败：话题内容不能为空。', 2000) if _.isEmpty($scope.newTopic.content)

      topicService.postNew $scope.newTopic
        .then ->
          $scope.scrollDelegate.scrollTop(false)
          $scope.newTopic = mkNewTopic()
          $scope.newTopicModal.hide()
          $timeout $scope.doRefresh
        .catch (error) ->
          toast('发布失败: ' + error?.data?.error_msg, 2000)

    doRefresh: ->
      if $scope.loading then return
      $scope.error = null
      $scope.hasMore = true
      loadTopics(refresh = true)

    loadMore: ->
      if $scope.loading or $scope.error then return
      loadTopics(refresh = false)

