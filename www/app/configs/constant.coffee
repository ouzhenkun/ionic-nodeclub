angular.module('ionic-nodeclub')

.constant 'API',
  #server: 'http://localhost:3000'
  server: 'https://cnodejs.org'
  #server: 'http://ionichina.com'
  path: '/api/'
  version: 'v1'

.constant 'config',
  TOPICS_PAGE_LIMIT: 15       # 每次加载topics为30个
  REPLIES_LATEST_DEFAULT: 30  # 最新回复默认显示30个
  REPLIES_LIKEABLE_ENABLE: 10 # 有10个回复以上才显示最赞回复
  REPLIES_LIKEABLE_LIMIT: 5   # 最赞回复默认显示Top 5
  TOAST_SHORT_DELAY: 2000     # 短的toast显示时长为2秒
  TOAST_LONG_DELAY: 3500      # 长的toast显示时长为3.5秒


.constant 'tabs', [
  {label: '全部', value: 'all'}
  {label: '精华', value: 'good'}
  {label: '分享', value: 'share'}
  {label: '问答', value: 'ask'}
  {label: '招聘', value: 'job'}
  {label: '吐槽', value: 'bb'}
]

