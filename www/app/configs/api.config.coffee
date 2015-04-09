angular.module('starter')

.config (RestangularProvider) ->
  RestangularProvider.setBaseUrl('http://ionichina.com/api/v1')
  RestangularProvider.setRestangularFields(id: 'id')

.config ($httpProvider) ->
  $httpProvider.interceptors.push ($q, storage) ->
    request: (config) ->
      config
    responseError: (rejection) ->
      if rejection.status is 403
        storage.remove 'user'
      $q.reject rejection

