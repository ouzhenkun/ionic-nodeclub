angular.module('starter')

.constant 'tabs', [
  {label: '全部', value: 'all'}
  {label: '精华', value: 'good'}
  {label: '分享', value: 'share'}
  {label: '问答', value: 'ask'}
  {label: '招聘', value: 'job'}
  {label: '吐槽', value: 'bb'}
]

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
      url: '/topics?:tab',
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
