angular.module('starter')

.directive 'focusOn', ($timeout) ->

  (scope, element, attrs) ->
    scope.$on 'focusOn', (event, name) ->
      $timeout ->
        if name is attrs.focusOn
          console.log 'focusOn', attrs.focusOn
          element[0].focus()
