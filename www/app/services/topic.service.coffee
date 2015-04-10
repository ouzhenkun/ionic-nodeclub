angular.module('starter')

.factory 'topicService', (
  $q
  Restangular
) ->

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
          #TODO extend?
          cache[topicId] = dbTopic
          resolve dbTopic.replies
        .catch reject

