angular.module('starter')

.controller 'RepliesCtrl', (
  $scope
  $ionicModal
  $stateParams
  topicService
  $ionicActionSheet
) ->

  loadReplies = (reload = false) ->
    $scope.loading = true
    topicService.getReplies $stateParams.topicId, reload
      .then (replies) ->
        $scope.replies = replies
      .catch (error) ->
        $scope.error = error
      .finally ->
        $scope.loading = false


  angular.extend $scope,
    loading: false
    error: null
    replies: null
    showAction: ->
      $ionicActionSheet.show
        buttons: [
          text: '点赞'
        ,
          text: '复制'
        ,
          text: '回复'
        ]
        buttonClicked: (index) ->
          switch index
            when 0
              console.log '点赞'
            when 1
              console.log '复制'
            else
              console.log '回复'
          return true

  loadReplies()
