angular.module('starter')

.factory 'focus', ($rootScope, $timeout) ->
  (name) ->
    $timeout ->
      console.log 'broadcast focusOn', name
      $rootScope.$broadcast('focusOn', name) if !_.isEmpty(name)
