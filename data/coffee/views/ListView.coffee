class ListView extends Backbone.View
  initialize: ->
    @listenTo @collection, 'reset', @onReset
    @listenTo @collection, 'change:favoriteState', @render
    @listenTo @collection, 'change:activeState', @onStateChange

    @listenTo @model, 'change:isFavoriteEnabled', @onCheckboxChange
    @listenTo @model, 'change:refreshProcess', @onRefreshProcess
    @listenTo @model, 'change:countryFilter', @addAll

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
    @$filterButton    = @$ 'i.filter'
    @$favoritesToggle = @$ '.checkbox'
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
    @renderProtocolButtons()

    filteredEntries = @collection
      .byCountry @model.get('countryFilter')
      .byProtocol @model.get('protocolFilter')
      .byFavorite @model.get('isFavoriteEnabled')

    _.each filteredEntries.models, @addOne, @

    @model.stopRefreshProcess()

  onCreateFavorite: (proxy) ->
    @collection.add proxy

  onCheckboxChange: ->
    @$favoritesToggle.toggleClass 'active'
    @onReset()

  onRefreshProcess: (model, value) ->
    @$content.toggleClass 'spinner', value

  toggleFavorites: ->
    @model.set 'isFavoriteEnabled', !@model.get 'isFavoriteEnabled'

  toggleFilterPanel: ->
    @$filters.toggleClass 'visible'
    @$filterButton.toggleClass 'active'

  updateCountryFilter: ->
    @model.set 'countryFilter', @$countryFilter.val()

  updateProtocolFilter: (e) ->
    $button = @$(e.target)
    $button.toggleClass 'active'

    @model.setProtocolState($button.text(), $button.hasClass 'active')

    @addAll()

  updateProtocolsIfNeeded: (protos) ->
    _.each protos, (newProtocol) =>
      if _.isUndefined @model.getProtocolState(newProtocol)
        @model.setProtocolState(newProtocol, true)

    @renderProtocolButtons()

  renderProtocolButtons: ->
    @$protocolButtons.empty()

    _.each (@model.get 'protocolFilter'), (proto, idx) =>
      @$protocolButtons.append $("<button>").text(idx)

    @$protocolButtons.find('button').each (idx, button) =>
      $(button).toggleClass 'active', @model.get('protocolFilter')[do $(button).text]

  onStateChange: (model) ->
    _.each(@collection.without(model), (proxy) -> proxy.set 'activeState', false) if model.get 'activeState'

  onReset: ->
    countryData = _.uniq @collection.map(
      (element) =>
        id       : element.get 'country'
        text     : element.get 'country'
        selected : _.contains(@model.get('countryFilter'), element.get 'country')
    ), (element) => element.text

    @$countryFilter.select2
      data: countryData
      minimumResultsForSearch: -1
      placeholder: i18next.t 'country'
      multiple: true
      maximumSelectionLength: 10
      width: '100%'

    @addAll()

