# Ionic Starter App
# angular.module is a global place for creating, registering and retrieving Angular modules
# 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
# the 2nd parameter is an array of 'requires'
# 'starter.controllers' is found in controllers.js

angular.module('starter', [
  'ionic'
  'starter.controllers'
])

.run ($ionicPlatform) ->

  $ionicPlatform.ready ->
    # Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
    # for form inputs)
    if window.cordova and window.cordova.plugins.Keyboard
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true)

    if window.StatusBar
      # org.apache.cordova.statusbar required
      StatusBar.styleDefault()

.config ($stateProvider, $urlRouterProvider) ->

  $stateProvider
    .state 'app',
      url: '/app'
      abstract: true
      templateUrl: 'templates/menu.html'
      controller: 'AppCtrl'

    .state 'app.lists',
      url: '/lists',
      views:
        menuContent:
          templateUrl: 'templates/lists.html'
          controller: 'ItemListsCtrl'

    .state 'app.detail',
      url: '/lists/:itemId'
      views:
        menuContent:
          templateUrl: 'templates/detail.html'
          controller: 'ItemDetailCtrl'

    .state 'app.settings',
      url: '/settings',
      views:
        menuContent:
          templateUrl: 'templates/settings.html'

  $urlRouterProvider.otherwise '/app/lists'
