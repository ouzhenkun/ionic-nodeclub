angular.module('starter')

.constant 'API',
  server: 'https://cnodejs.org'
  #server: 'http://ionichina.com'
  path: '/api/v1'

.config (RestangularProvider, API) ->
  RestangularProvider.setBaseUrl(API.server + API.path)
  RestangularProvider.setRestangularFields(id: 'id')

.config ($httpProvider) ->
  $httpProvider.interceptors.push ($q, storage) ->
    request: (config) ->
      config
    responseError: (rejection) ->
      #if rejection.status is 403
        #storage.remove 'user'
      $q.reject rejection

