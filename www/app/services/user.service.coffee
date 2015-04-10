angular.module('starter')

.factory 'userService', (
  $q
  storage
  Restangular
  $ionicLoading
) ->

  users = {}

  reset: ->
    users = {}

  login: (token) ->
    $ionicLoading.show(template: '登录中...')
    $q (resolve, reject) ->
      Restangular
        .all('accessToken')
        .post(accesstoken: token)
        .then (user) ->
          storage.set 'user', angular.extend(user, token: token)
          resolve(user)
          $ionicLoading.show
            template: '登录成功，欢迎您: ' + user?.loginname
            duration: 1000
            noBackdrop: true
        .catch (error) ->
          reject(error)
          $ionicLoading.show
            template: '登录失败: ' + error?.data?.error_msg
            duration: 1000
            noBackdrop: true

  logout: ->
    @reset()
    #storage.remove 'user'
    $ionicLoading.show
      template: '您已登出',
      duration: 1000
      noBackdrop: true

  hasCollect: (topicId) ->
    $q (resolve, reject) =>
      user = storage.get('user')
      @get(user?.loginname)
        .then (dbUser) ->
           resolve _.find(dbUser.collect_topics, id:topicId)?
        .catch reject

  collectTopic: (topic) ->
    $q (resolve, reject) ->
      user = storage.get('user')
      Restangular
        .all('topic/collect')
        .post(accesstoken: user?.token, topic_id: topic.id)
        .then (resp) ->
          if cacheUser = users[user.loginname]
            cacheUser.collect_topics.push topic
          $ionicLoading.show
            template: '收藏成功',
            duration: 1000
            noBackdrop: true
          resolve(resp)
        .catch reject

  deCollectTopic: (topic) ->
    $q (resolve, reject) ->
      user = storage.get('user')
      Restangular
        .all('topic/de_collect')
        .post(accesstoken: user?.token, topic_id: topic.id)
        .then (resp) ->
          if cacheUser = users[user.loginname]
            _.remove(cacheUser.collect_topics, id:topic.id)
          resolve(resp)
        .catch reject

  get: (loginname, reload = false) ->
    $q (resolve, reject) ->
      if _.isEmpty(loginname)
        return reject('错误的 loginname: ' + loginname)
      if !reload and cacheUser = users[loginname]
        return resolve cacheUser
      Restangular
        .one('user', loginname)
        .get()
        .then (resp) ->
          dbUser = resp.data
          users[loginname] = dbUser
          resolve dbUser
        .catch reject

