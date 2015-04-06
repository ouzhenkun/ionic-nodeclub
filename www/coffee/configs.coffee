angular.module('starter')

.config (RestangularProvider) ->
  RestangularProvider.setBaseUrl('http://ionichina.com/api/v1')
  RestangularProvider.setRestangularFields(id: 'id')

.config ($stateProvider, $urlRouterProvider) ->

  $stateProvider
    .state 'app',
      url: '/app'
      abstract: true
      templateUrl: 'templates/menu.html'
      controller: 'AppCtrl'

    .state 'app.topics',
      url: '/topics',
      views:
        menuContent:
          templateUrl: 'templates/topics.html'
          controller: 'TopicsCtrl'

    .state 'app.topic',
      url: '/topics/:topicId'
      views:
        menuContent:
          templateUrl: 'templates/topic.html'
          controller: 'TopicCtrl'

    .state 'app.settings',
      url: '/settings',
      views:
        menuContent:
          templateUrl: 'templates/settings.html'

  $urlRouterProvider.otherwise '/app/topics'
