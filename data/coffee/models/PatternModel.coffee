class PatternModel extends Backbone.Model
  idAttribute: 'address'

  defaults: ->
    address: null

  messagePassing:
    'update': 'add-blacklist'
    'delete': 'remove-blacklist'