angular.module('ionic-nodeclub')

.controller 'MainCtrl', (
  tabs
  $scope
  storage
  authService
  messageService
) ->

  angular.extend $scope,
    me: null
    # 我要在menu.html里面显示一些tab
    tabs: tabs
    # 我要在main.html和user.html里调用-
    # authService的登录和退出方法
    auth: authService
    msg: messageService

  $scope.$on 'auth.userUpdated', (event, user) ->
    $scope.me = user
    messageService.refreshUnreadCount()

  $scope.$on 'auth.userLogout', ->
    $scope.me = null
    messageService.reset()
