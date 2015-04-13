angular.module('starter')

.filter 'toMarkdown', ->

  (htmlInput) ->
    if _.isEmpty(htmlInput) then return ''
    toMarkdown(htmlInput)
      .replace(/<([^>]+)>/ig, '')
      .replace(/(?:\r\n|\r|\n)/g, '')
