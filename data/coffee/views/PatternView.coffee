class PatternView extends Backbone.View
  tagName: ->
    'div'

  attributes: ->
    'class': 'pattern'

  events: ->
    'click .remove'  : 'destroy'

  initialize: ->
    @listenTo @model, 'change', @render
    @listenTo @model, 'destroy', @remove

    @template = Handlebars.templates['blacklistElement']

  render: ->
    $(@el).html @template @model.toJSON()

    return @

  destroy: ->
    @model.destroy()