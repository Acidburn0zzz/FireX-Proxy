class ProxyStateModel extends Backbone.Model
  url: '#/filters'

  initialize: ->
    @fetch()

    @on 'change', () => @save()

  getProtocolState: (proto) ->
    return @get('protocolFilter')[proto]

  setProtocolState: (proto, newState) ->
    newProtocolFilter        = {}
    newProtocolFilter[proto] = newState

    @set('protocolFilter', _.extend(@get('protocolFilter'), newProtocolFilter))

    @trigger('change')

  save: (key, val, options) ->
    browser.storage.local.set({
      filters:
        protocolFilter: @get 'protocolFilter'
        countryFilter: @get 'countryFilter'
    })

    return Backbone.Model.prototype.save.call(this, key, val, options)

  fetch: (options)  ->
    browser.storage.local.get('filters').then (persistent) =>
      _.defaults persistent,
        filters:
          countryFilter: null,
          protocolFilter: {}

      @set(persistent.filters)

    return Backbone.Model.prototype.fetch.call(this, options)

  startRefreshProcess: ->
    @set 'refreshProcess', true

  stopRefreshProcess: ->
    @set 'refreshProcess', false
    
  defaults: ->
    isFavoriteEnabled     : false
    refreshProcess        : false
    protocolFilter        : {}
    countryFilter         : null