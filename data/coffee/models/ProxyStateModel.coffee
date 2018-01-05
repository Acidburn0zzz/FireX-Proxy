class ProxyStateModel extends Backbone.Model
  startRefreshProcess: ->
    @set 'refreshProcess', true

  stopRefreshProcess: ->
    @set 'refreshProcess', false
    
  defaults: ->
    isFavoriteEnabled     : false
    isFilterPanelActive   : false
    refreshProcess        : false
    protocolFilter        : {}
    countryFilter         : null