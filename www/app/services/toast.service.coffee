angular.module('starter')

.factory 'toast', ($ionicLoading) ->

  (message, duration = 1000, noBackdrop = true) ->
    $ionicLoading.show
      template: message
      duration: duration
      noBackdrop: noBackdrop
