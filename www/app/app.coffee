angular.module('ionic-nodeclub', [
  'ionic'
  'ngCordova'
  'restangular'
  'angularMoment'
  'btford.markdown'
  'monospaced.elastic'
])

.run (
  $state
  amMoment
  $timeout
  $rootScope
  $ionicLoading
  $ionicHistory
  $ionicPlatform
  $cordovaKeyboard
  $cordovaStatusbar
  IONIC_BACK_PRIORITY
) ->

  amMoment.changeLocale('zh-cn')

  $ionicPlatform.ready ->
    # Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
    # for form inputs)
    if window.cordova
      $cordovaKeyboard.hideAccessoryBar(true)

    if window.StatusBar
      $cordovaStatusBar.style(0)

  #
  # 我要实现按两次返回按钮才能退出APP
  #
  $ionicPlatform.registerBackButtonAction ->
    # 我要先返回上一个页面，如果有的话
    if backView = $ionicHistory.backView()
      return backView.go()

    # 我定义点击两次返回按钮退出APP的时间间隔
    EXIT_APP_TIMEOUT = 1500

    # 我提示用户再按一次返回按钮会退出APP
    $ionicLoading.show
      template: '再按一次退出'
      duration: EXIT_APP_TIMEOUT
      noBackdrop: true

    # 我注册一个返回按钮的callback
    # 因为现在$ionicLoading正在显示, 为了覆盖它原来的逻辑
    # 所以我让priority比它原来的值多 + 1
    deregisterExitAppAction = $ionicPlatform.registerBackButtonAction ->
      ionic.Platform.exitApp()
    , IONIC_BACK_PRIORITY.loading+1

    $timeout(deregisterExitAppAction, EXIT_APP_TIMEOUT)

  , IONIC_BACK_PRIORITY.view+1


  # 我在修复浏览器刷新/后退导致'nav button'显示异常的BUG
  $rootScope.$on '$stateChangeStart', (event, toState) ->
    # 通过设置historyRoot可以让'nav button'的状态重置
    if toState.historyRoot
      $ionicHistory.nextViewOptions
        historyRoot: true
