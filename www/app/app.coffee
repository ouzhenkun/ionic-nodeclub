# Ionic Starter App
# angular.module is a global place for creating, registering and retrieving Angular modules
# 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
# the 2nd parameter is an array of 'requires'
# 'starter.controllers' is found in controllers.js

angular.module('starter', [
  'ionic'
  'restangular'
  'angularMoment'
  'btford.markdown'
  'monospaced.elastic'
])

.run (
  amMoment
  $rootScope
  $ionicPlatform
  $ionicHistory
) ->
  # TODO reload user

  amMoment.changeLocale('zh-cn')

  $ionicPlatform.ready ->
    # Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
    # for form inputs)
    if window.cordova and window.cordova.plugins.Keyboard
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true)

    if window.StatusBar
      # org.apache.cordova.statusbar required
      StatusBar.styleDefault()

  # FIX 浏览器刷新/后退 nav icon 异常
  $rootScope.$on '$stateChangeStart', (event, toState) ->
    # 如何是回到Home页面，设置historyRoot
    if toState.name is 'app.topics'
      $ionicHistory.nextViewOptions
        historyRoot: true
