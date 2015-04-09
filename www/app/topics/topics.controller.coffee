angular.module('starter')

.controller 'TopicsCtrl', ($scope, tabs, Restangular, $stateParams) ->

  PAGE_LIMIT = 10
  tabParam = $stateParams.tab ? tabs[0].value

  loadTopics = ->
    $scope.loading = true
    page = ~~($scope.topics.length / PAGE_LIMIT) + 1
    Restangular
      .one('topics')
      .get(page: page, limit: PAGE_LIMIT, tab: tabParam)
      .then (result) ->
        newTopics = result.data
        $scope.topics = $scope.topics.concat(newTopics)
        $scope.hasMoreTopics = newTopics.length is PAGE_LIMIT
      .finally ->
        $scope.loading = false
        $scope.$broadcast('scroll.refreshComplete')
        $scope.$broadcast('scroll.infiniteScrollComplete')

  # Export Properties
  angular.extend $scope,
    loading: false
    tabLabel: _.find(tabs, value: tabParam)?.label
    topics: []
    hasMoreTopics: true
    doRefresh: ->
      if $scope.loading then return
      $scope.topics = []
      $scope.hasMoreTopics = true
      loadTopics()
    loadMore: ->
      if $scope.loading then return
      loadTopics()

