class Router extends Backbone.Router
  container: "#primary-content"

  routes: ->
    'index'     : 'index',
    'blacklist' : 'blacklist',

  initialize: ->
    @mCollection = new Menu
    @pCollection = new ProxyList
    @bCollection = new Patterns

    @createMenu()
    @index()
    
  index: ->
    $(@container).html new ListView(collection: @pCollection, model: new ProxyStateModel).render().el

  blacklist: ->
    $(@container).html new PatternPageView(collection: @bCollection, model: new PatternStateModel).render().el

  createMenu: ->
    new MenuView
      collection: @mCollection

    @mCollection.create
      resource    : '#/index'
      icon        : 'list'
      placeholder : i18next.t "proxymenu"
      isActive    : true

    @mCollection.create
      resource    : '#/blacklist'
      icon        : 'settings'
      placeholder : i18next.t "blacklist"