angular.module('starter')

.controller 'TopicCtrl', ($scope, $ionicModal, $stateParams, Restangular) ->

  $ionicModal
    .fromTemplateUrl('app/topic/replies-modal.html', scope: $scope)
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

