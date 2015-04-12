angular.module('starter')

.factory 'topicService', (
  $q
  storage
  Restangular
) ->

  #TODO config
  PAGE_LIMIT = 10
  cache = {}

  reset: ->
    cache = {}

  loadMore: (tab, from = 0) ->
    $q (resolve, reject) ->
      page = ~~(from / PAGE_LIMIT) + 1
      Restangular
        .one('topics')
        .get(page: page, limit: PAGE_LIMIT, tab: tab)
        .then (resp) ->
          newTopics = resp.data
          # 更新cache topics
          _.each newTopics, (topic) ->
            cache[topic.id] = topic
          resolve
            topics: newTopics
            hasMore: newTopics.length is PAGE_LIMIT
        .catch resolve

  getDetail: (topicId, reload) ->
    $q (resolve, reject) ->
      if !reload and topic = cache[topicId]
        return resolve topic
      Restangular
        .one('topic', topicId)
        .get()
        .then (resp) ->
          dbTopic = resp.data
          cache[topicId] = dbTopic
          # TODO return a clone ?
          resolve dbTopic
        .catch reject

  getReplies: (topicId, reload) ->
    $q (resolve, reject) ->
      if !reload and replies = cache[topicId]?.replies
        return resolve replies
      Restangular
        .one('topic', topicId)
        .get()
        .then (resp) ->
          dbTopic = resp.data
          # TODO extend ?
          cache[topicId] = dbTopic
          # TODO return a clone ?
          console.log dbTopic.replies
          resolve dbTopic.replies
        .catch reject

  toggleLikeReply: (reply) ->
    $q (resolve, reject) ->
      user = storage.get 'user'
      Restangular
        .one('reply', reply.id)
        .post('ups', accesstoken: user?.token)
        .then (resp) ->
          switch resp.action
            when 'up'
              reply.ups.push user.id
            when 'down'
              _.pull reply.ups, user.id
            else
              # TODO 错误处理
              console.log 'unknown action: ' + resp.action
          resolve(resp.action)
        .catch reject

