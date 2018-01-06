class Patterns extends Backbone.Collection
  messagePassing:
    'read': 'get-blacklist'

  constructor: (options) ->
    super options

    @model = PatternModel

  parse: (patterns) ->
    _.map(patterns, (pattern) -> address: pattern)