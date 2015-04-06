angular.module('starter')

.controller('AppCtrl', ($scope, $ionicModal, $timeout) ->
  # Form data for the login modal
  $scope.loginData = {}

  # Create the login modal that we will use later
  $ionicModal.fromTemplateUrl('templates/login.html', scope: $scope).then (modal) ->
    $scope.modal = modal
 
  # Triggered in the login modal to close it
  $scope.closeLogin = ->
    $scope.modal.hide()

  # Open the login modal
  $scope.login = ->
    $scope.modal.show()

  # Perform the login action when the user submits the login form
  $scope.doLogin = ->
    console.log 'Doing login', $scope.loginData
    # Simulate a login delay. Remove this and replace with your login
    # code if using a login system
    $timeout (-> $scope.closeLogin()), 1000
)

.controller('TopicsCtrl', ($scope, Restangular) ->

  loading = false
  currentPage = 1
  pageLimit = 10

  loadTopics = ->
    loading = true
    Restangular
      .one('topics')
      .get(page: currentPage, limit: pageLimit)
      .then (result) ->
        newTopics = result.data
        $scope.topics = $scope.topics.concat(newTopics)
        $scope.hasMoreTopics = newTopics.length is pageLimit
      .finally ->
        loading = false
        $scope.$broadcast('scroll.refreshComplete')
        $scope.$broadcast('scroll.infiniteScrollComplete')

  angular.extend $scope,
    topics: []
    hasMoreTopics: true
    doRefresh: ->
      if loading then return
      currentPage = 1
      $scope.topics = []
      $scope.hasMoreTopics = true
      loadTopics()
    loadMore: ->
      if loading then return
      currentPage += 1
      loadTopics()
)

.controller 'TopicCtrl', ($scope, $stateParams, Restangular) ->
  Restangular
    .one('topic', $stateParams.topicId)
    .get()
    .then (result) ->
      console.log result
      $scope.topic = result?.data
