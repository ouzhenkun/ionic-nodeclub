angular.module('starter')

.filter 'tabLabel', (tabs) ->

  (tabValue) ->
    _.find(tabs, value:tabValue)?.label ? '其他'
