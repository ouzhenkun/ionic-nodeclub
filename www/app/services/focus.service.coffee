angular.module('starter')

.factory 'focus', ($rootScope, $timeout) ->

  (name) ->
    broadcastFocusEvent = ->
      $rootScope.$broadcast('focusOn', name) if !_.isEmpty(name)
    $timeout broadcastFocusEvent
