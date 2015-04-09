angular.module('starter')

#TODO refactor 拆分出来几个 ctrl

.controller 'AppCtrl', ($scope, tabs, $ionicModal) ->

  $ionicModal
    .fromTemplateUrl('templates/login.html', scope: $scope)
    .then (modal) ->
      $scope.loginModal = modal

  # Export Properties
  angular.extend $scope,
    tabs: tabs
    loginModal: null
    showLogin: ->
      $scope.loginModal.show()
    closeLogin: ->
      $scope.loginModal.hide()


.controller 'TopicsCtrl', ($scope, tabs, Restangular, $stateParams) ->

  PAGELIMIT = 10
  tabParam = $stateParams.tab ? 'all'

  loadTopics = ->
    $scope.loading = true
    page = ~~($scope.topics.length / PAGELIMIT) + 1
    Restangular
      .one('topics')
      .get(page: page, limit: PAGELIMIT, tab: tabParam)
      .then (result) ->
        newTopics = result.data
        $scope.topics = $scope.topics.concat(newTopics)
        $scope.hasMoreTopics = newTopics.length is PAGELIMIT
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

.controller 'TopicCtrl', ($scope, $ionicModal, $stateParams, Restangular) ->

  $ionicModal
    .fromTemplateUrl('templates/replies.html', scope: $scope)
    .then (modal) ->
      $scope.repliesModal = modal

  Restangular
    .one('topic', $stateParams.topicId)
    .get()
    .then (result) ->
      $scope.topic = result?.data

  angular.extend $scope,
    topic: null
    repliesModal: null
    showReplies: ->
      $scope.repliesModal.show()
    closeReplies: ->
      $scope.repliesModal.hide()

