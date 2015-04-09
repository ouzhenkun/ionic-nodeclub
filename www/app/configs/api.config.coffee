angular.module('starter')

.config (RestangularProvider) ->
  RestangularProvider.setBaseUrl('http://ionichina.com/api/v1')
  RestangularProvider.setRestangularFields(id: 'id')

