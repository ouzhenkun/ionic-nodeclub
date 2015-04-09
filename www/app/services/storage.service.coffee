angular.module('starter')

.factory 'storage', ($window) ->

  localStorage = $window.localStorage

  genKey = (key) -> 'ionichina-' + key

  get: (key) ->
    key = genKey key
    value = localStorage.getItem key
    JSON.parse(value)

  set: (key, value) ->
    key = genKey key
    value = JSON.stringify value
    localStorage.setItem(key, value)

  remove: (key) ->
    key = genKey key
    localStorage.removeItem key

  clear: ->
    localStorage.clear()

