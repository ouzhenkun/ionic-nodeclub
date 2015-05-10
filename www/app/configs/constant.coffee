angular.module('ionic-nodeclub')

.constant 'API',
  servers: ['https://cnodejs.org', 'http://ionichina.com']
  server: localStorage.server ? @servers[0]
  #server: 'http://ionichina.com'
  path: '/api/'
  version: 'v1'

.constant 'config',
  TOPICS_PAGE_LIMIT: 15              # 每次加载topics为30个
  LATEST_REPLIES_DEFAULT_NUM: 30     # 最新回复默认显示30个
  POP_REPLIES_TRIGGER_NUM: 10        # 有10个回复以上才显示最赞回复
  POP_REPLIES_LIMIT: 5               # 最赞回复默认显示5个
  TOAST_SHORT_DELAY: 2000            # 短的toast显示时长为2秒
  TOAST_LONG_DELAY: 3500             # 长的toast显示时长为3.5秒

.constant 'tabs', [
  {label: '全部', value: 'all'}
  {label: '精华', value: 'good'}
  {label: '分享', value: 'share'}
  {label: '问答', value: 'ask'}
  {label: '招聘', value: 'job'}
  {label: '吐槽', value: 'bb'}
]

