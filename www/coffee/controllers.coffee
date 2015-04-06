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
  Restangular
    .one('topics')
    .get()
    .then (result) ->
      $scope.topics = result?.data
)

.controller 'TopicCtrl', ($scope, $stateParams, Restangular) ->
  Restangular
    .one('topic', $stateParams.topicId)
    .get()
    .then (result) ->
      console.log result
      $scope.topic = result?.data
