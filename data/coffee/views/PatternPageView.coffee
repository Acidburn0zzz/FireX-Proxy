class PatternPageView extends Backbone.View
  events: ->
    'submit .bottom-menu': 'createElement'

  id: ->
    'pattern'

  initialize: ->
    @listenTo @collection, 'add', @addOne
    @listenTo @collection, 'reset', @addAll

    @template = Handlebars.templates['blacklist']

  render: ->
    $(@el).html @template @model.toJSON()

    @listPatterns = @$ '.content-wrapper'
    @patternInput = @$ 'input[name="blacklist-element"]'

    @addAll()

    @collection.fetch() if not @collection.length

    return @

  addAll: ->
    @collection.each @addOne, @

  addOne: (pattern) ->
    @listPatterns.append new PatternView(model: pattern).render().el

  createElement: (e) ->
    e.preventDefault()

    if @patternInput.val().length
      pattern = new PatternModel
        address: @patternInput.val()

      @collection.add pattern if do pattern.save

    $(e.target).trigger 'reset'