angular.module('starter')

.filter 'prefixServerUrl', (API) ->

  (input) ->
    if input?.indexOf('http') is 0
      return input
    API.server + input
