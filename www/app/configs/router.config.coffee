angular.module('starter')

.config ($stateProvider, $urlRouterProvider, tabs) ->

  $stateProvider
    .state 'app',
      url: '/app'
      abstract: true
      templateUrl: 'app/main/main.html'
      controller: 'MainCtrl'

    .state 'app.topics',
      url: '/topics?:tab',
      views:
        menuContent:
          templateUrl: 'app/topics/topics.html'
          controller: 'TopicsCtrl'

    .state 'app.topic',
      url: '/topics/:topicId'
      views:
        menuContent:
          templateUrl: 'app/topic/topic.html'
          controller: 'TopicCtrl'

  $urlRouterProvider.otherwise "/app/topics?tab=#{tabs[0].value}"

