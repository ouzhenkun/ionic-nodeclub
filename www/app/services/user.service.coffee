angular.module('starter')

.factory 'userService', (
  $q
  storage
  Restangular
) ->

  cache = {}

  reset: ->
    cache = {}

  login: (token) ->
    $q (resolve, reject) ->
      Restangular
        .all('accessToken')
        .post(accesstoken: token)
        .then (user) ->
          storage.set 'user', angular.extend(user, token: token)
          resolve user
        .catch reject

  logout: ->
    @reset()
    # TODO 加 fakeLogout config
    #storage.remove 'user'

  getDetail: (loginname, reload = false) ->
    $q (resolve, reject) ->
      if _.isEmpty(loginname)
        return reject('错误的 loginname: ' + loginname)
      if !reload and cacheUser = cache[loginname]
        return resolve cacheUser
      Restangular
        .one('user', loginname)
        .get()
        .then (resp) ->
          dbUser = resp.data
          cache[loginname] = dbUser
          resolve dbUser
        .catch reject

  collectTopic: (topic) ->
    $q (resolve, reject) ->
      user = storage.get('user')
      Restangular
        .all('topic/collect')
        .post(accesstoken: user?.token, topic_id: topic.id)
        .then (resp) ->
          # 更新已经被cache的user信息
          if cacheUser = cache[user.loginname]
            cacheUser.collect_topics.push topic
          resolve resp
        .catch reject

  deCollectTopic: (topic) ->
    $q (resolve, reject) ->
      user = storage.get('user')
      Restangular
        .all('topic/de_collect')
        .post(accesstoken: user?.token, topic_id: topic.id)
        .then (resp) ->
          # 更新已经被cache的user信息
          if cacheUser = cache[user.loginname]
            _.remove(cacheUser.collect_topics, id:topic.id)
          resolve resp
        .catch reject

  checkCollect: (topicId) ->
    $q (resolve, reject) =>
      user = storage.get('user')
      @getDetail(user?.loginname)
        .then (dbUser) ->
          isCollected = _.find(dbUser.collect_topics, id:topicId)?
          resolve isCollected
        .catch reject

