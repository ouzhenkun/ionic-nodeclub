angular.module('starter')

.filter 'prefixUrl', (API) ->

  (input) ->
    if /^http/i.test(input)
      return input
    if /^\/\//i.test(input)
      return 'https:' + input
    API.server + input
