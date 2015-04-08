angular.module('starter')

.controller 'AppCtrl', ($scope, tabs) ->

  # Export Properties
  angular.extend $scope,
    tabs: tabs


.controller 'TopicsCtrl', ($scope, tabs, Restangular, $stateParams) ->

  pageLimit = 10

  loadTopics = ->
    $scope.loading = true
    page = ~~($scope.topics.length / pageLimit) + 1
    Restangular
      .one('topics')
      .get(page: page, limit: pageLimit, tab: $stateParams.tab)
      .then (result) ->
        newTopics = result.data
        $scope.topics = $scope.topics.concat(newTopics)
        $scope.hasMoreTopics = newTopics.length is pageLimit
      .finally ->
        $scope.loading = false
        $scope.$broadcast('scroll.refreshComplete')
        $scope.$broadcast('scroll.infiniteScrollComplete')

  # Export Properties
  angular.extend $scope,
    loading: false
    tabLabel: _.find(tabs, value:$stateParams.tab ? 'all')?.label
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

.controller 'TopicCtrl', ($scope, $stateParams, Restangular) ->

  Restangular
    .one('topic', $stateParams.topicId)
    .get()
    .then (result) ->
      $scope.topic = result?.data
