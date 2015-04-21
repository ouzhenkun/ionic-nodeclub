angular.module('ionic-nodeclub')

.controller 'MessagesCtrl', (
  $scope
  messageService
  $stateParams
) ->

  loadMessages = (refresh) ->
    $scope.loading = true
    messageService.getMessages refresh
      .then (data) ->
        $scope.has_read_messages = data.has_read_messages
        $scope.hasnot_read_messages = data.hasnot_read_messages
      .catch (error) ->
        $scope.error = error
      .finally ->
        $scope.loading = false
        $scope.$broadcast('scroll.refreshComplete')

  angular.extend $scope,
    has_read_messages: null
    hasnot_read_messages: null
    loading: false
    error: null
    doRefresh: ->
      loadMessages(refresh = true)
    markAsRead: ->
      messageService.markAllAsRead()
        .then -> loadMessages(refresh = true)

  loadMessages(refresh = false)
