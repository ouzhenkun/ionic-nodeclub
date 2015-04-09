angular.module('starter')

.config ($stateProvider, $urlRouterProvider, tabs) ->

  $stateProvider
    .state 'app',
      url: '/app'
      abstract: true
      templateUrl: 'app/main/main.html'
      controller: 'MainCtrl'

    .state 'app.topics',
      url: '/topics/:tab',
      views:
        mainContent:
          templateUrl: 'app/topics/topics.html'
          controller: 'TopicsCtrl'

    .state 'app.topic',
      url: '/topic/:topicId'
      views:
        mainContent:
          templateUrl: 'app/topic/topic.html'
          controller: 'TopicCtrl'

    .state 'app.user',
      url: '/user/:loginname'
      views:
        mainContent:
          templateUrl: 'app/user/user.html'
          controller: 'UserCtrl'

  $urlRouterProvider.otherwise "/app/topics/#{tabs[0].value}"

