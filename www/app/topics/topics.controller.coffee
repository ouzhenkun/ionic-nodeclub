angular.module('starter')

.controller 'TopicsCtrl', (
  tabs
  toast
  $scope
  $timeout
  $ionicModal
  $stateParams
  topicService
  $ionicScrollDelegate
) ->

  $ionicModal
    .fromTemplateUrl('app/topics/new-topic-modal.html', scope: $scope)
    .then (modal) ->
      $scope.newTopicModal = modal

  selectedTab = $stateParams.tab ? tabs[0].value

  loadTopics = ->
    $scope.loading = true
    topicService.loadMore selectedTab, $scope.topics.length
      .then (resp) ->
        $scope.topics = $scope.topics.concat(resp.topics)
        $scope.hasMoreTopics = resp.hasMore
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
    hasMoreTopics: true
    scrollDelegate: $ionicScrollDelegate.$getByHandle('topics-handle')
    loading: false
    error: null
    selectedTab: selectedTab
    topics: []
    tabs: _.filter(tabs, (t) -> t.value isnt 'all')
    newTopic: mkNewTopic()

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
      $scope.topics = []
      $scope.error = null
      $scope.hasMoreTopics = true
      loadTopics()

    loadMore: ->
      if $scope.loading or $scope.error then return
      loadTopics()

