angular.module('starter')

.controller 'TopicsCtrl', (
  tabs
  $scope
  Restangular
  $stateParams
) ->

  PAGE_LIMIT = 10
  selectedTab = $stateParams.tab ? tabs[0].value

  loadTopics = ->
    $scope.loading = true
    page = ~~($scope.topics.length / PAGE_LIMIT) + 1
    Restangular
      .one('topics')
      .get(page: page, limit: PAGE_LIMIT, tab: selectedTab)
      .then (result) ->
        newTopics = result.data
        $scope.topics = $scope.topics.concat(newTopics)
        $scope.hasMoreTopics = newTopics.length is PAGE_LIMIT
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

