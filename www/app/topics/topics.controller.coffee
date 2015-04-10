angular.module('starter')

.controller 'TopicsCtrl', (
  tabs
  $scope
  topicService
  $stateParams
) ->

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

  # Export Properties
  angular.extend $scope,
    loading: false
    error: null
    selectedTab: selectedTab
    topics: []
    hasMoreTopics: true
    doRefresh: ->
      if $scope.loading then return
      $scope.topics = []
      $scope.error = null
      $scope.hasMoreTopics = true
      loadTopics()
    loadMore: ->
      if $scope.loading or $scope.error then return
      loadTopics()

