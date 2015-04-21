angular.module('ionic-nodeclub')

.directive 'messageTile', ->
  restrict: 'E'
  templateUrl: 'app/directives/messageTile.html'
  scope:
    message: '='
