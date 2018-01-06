class ListView extends Backbone.View
  initialize: ->
    @listenTo @collection, 'reset', @addAll
    @listenTo @collection, 'change:favoriteState', @render
    @listenTo @collection, 'change:activeState', @onStateChange

    @listenTo @model, 'change:isFavoriteEnabled', @onCheckboxChange
    @listenTo @model, 'change:refreshProcess', @onRefreshProcess
    @listenTo @model, 'change:countryFilter', @render
    @listenTo @model, 'change:isFilterPanelActive', @render

    @template = Handlebars.templates['proxyList']

  events: ->
    'click .filter'                              : 'toggleFilterPanel'
    'click .refresh'                             : () => @update(true)
    'click .checkbox'                            : 'toggleFavorites'
    'change [name="country"]'                    : 'updateCountryFilter'
    'click .protocol-selector button'            : 'updateProtocolFilter'

  render: ->
    $(@el).html @template @model.toJSON()

    @$table           = @$ '#proxy-list-box'
    @$content         = @$ '.content-wrapper'
    @$filters         = @$ '.filters'
    @$countryFilter   = @$ '[name="country"]'
    @$protocolButtons = @$ '.protocol-selector'

    @addAll()

    @update() if not @collection.length

    return @

  update: (force = false) ->
    @collection.fetch(force)

    @model.startRefreshProcess()

    @$table.empty()

  addOne: (proxy) ->
    view = new ProxyView model: proxy

    @$table.append view.render().el

  addAll: ->
    @$table.empty()

    @updateProtocolsIfNeeded(@collection.getProtocols())

    filteredEntries = @collection
      .byCountry @model.get('countryFilter')
      .byProtocol @model.get('protocolFilter')
      .byFavorite @model.get('isFavoriteEnabled')
    _.each filteredEntries.models, @addOne, @

    countryData = _.uniq @collection.map(
      (element) =>
        id       : element.get 'country'
        text     : element.get 'country'
        selected : _.contains(@model.get('countryFilter'),  element.get 'country')
    ), (element) => element.text

    @$countryFilter.select2
      data: countryData
      minimumResultsForSearch: -1,
      placeholder: 'country',
      multiple: true
      width: '100%'

    @model.stopRefreshProcess()

  onCreateFavorite: (proxy) ->
    @collection.add proxy

  onCheckboxChange: ->
    @render()

  onRefreshProcess: (model, value) ->
    @$content.toggleClass 'spinner', value

  toggleFavorites: ->
    @model.set 'isFavoriteEnabled', !@model.get 'isFavoriteEnabled'

  toggleFilterPanel: ->
    @model.set 'isFilterPanelActive', !@model.get 'isFilterPanelActive'

  updateCountryFilter: ->
    @model.set 'countryFilter', @$countryFilter.val()

  updateProtocolFilter: (e) ->
    $button = @$(e.target)
    $button.toggleClass 'active', !$button.hasClass('active');
    @model.get('protocolFilter')[$button.text()] = $button.hasClass 'active'
    @addAll()

  updateProtocolsIfNeeded: (protos) ->
    _.each protos, (newProtocol) =>
      if _.isUndefined (@model.get 'protocolFilter')[newProtocol]
        @model.get('protocolFilter')[newProtocol] = true

        @$protocolButtons.append $("<button>").text(newProtocol)

    @$protocolButtons.find('button').each (idx, button) =>
      $(button).toggleClass 'active', @model.get('protocolFilter')[do $(button).text]

  onStateChange: (model) ->
    _.each(@collection.without(model), (proxy) -> proxy.set 'activeState', false) if model.get 'activeState'