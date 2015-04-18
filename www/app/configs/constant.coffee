angular.module('starter')

.constant 'API',
  #server: 'http://localhost:3000'
  server: 'https://cnodejs.org'
  #server: 'http://ionichina.com'
  path: '/api/'
  version: 'v1'

.constant 'config',
  TOPICS_PAGE_LIMIT: 15


.constant 'tabs', [
  {label: '全部', value: 'all'}
  {label: '精华', value: 'good'}
  {label: '分享', value: 'share'}
  {label: '问答', value: 'ask'}
  {label: '招聘', value: 'job'}
  {label: '吐槽', value: 'bb'}
]

