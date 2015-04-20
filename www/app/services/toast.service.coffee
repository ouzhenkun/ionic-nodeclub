angular.module('ionic-nodeclub')

.factory 'toast', ($ionicLoading, $timeout) ->

  (message, duration = 1000, noBackdrop = true) ->
    #
    # 我加 $timeout 为了避免同时调用 $ionicLoading.hide 的时候 toast 也被关掉
    #
    # FIXME
    # 请换掉，不要用 $ionicLoading 和 这个有冲突
    #
    $timeout ->
      $ionicLoading.show
        template: message
        duration: duration
        noBackdrop: noBackdrop
