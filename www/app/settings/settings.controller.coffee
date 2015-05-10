angular.module('ionic-nodeclub')

.controller 'SettingsCtrl', (
  API
  toast
  $scope
  $state
  $window
  Restangular
  $ionicLoading
) ->

  # TODO
  # 自动检查更新
  # http://fir.im/api/v2/app/version/5540b7aefe9978f3100002f4
  #
  # 打包的时候设置当前版本
  # 设置页面
