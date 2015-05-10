angular.module('ionic-nodeclub')

.controller 'SettingsCtrl', (
  $scope
  settings
) ->

  angular.extend $scope,
    settings: settings.get()
    updateSettings: ->
      settings.set($scope.settings)

  # TODO
  # 1.打包的时候设置当前版本
  # 2.自动检查更新: http://fir.im/api/v2/app/version/5540b7aefe9978f3100002f4
