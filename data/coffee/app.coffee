$ ->
  _.extend Backbone.Validation.callbacks,
    valid: (view) ->
      view
        .$el
        .find('.validation-state')
        .removeClass('failure')
        .addClass('done')
    invalid: (view) ->
      view
        .$el
        .find('.validation-state')
        .removeClass('done')
        .addClass('failure')

  Handlebars.registerHelper 't', (key) -> new Handlebars.SafeString i18next.t key

  i18next.init
    lng: browser.i18n.getUILanguage()
    resources:
      en:
        translation:
          "blacklist": "Blacklist"
          "favorites": "Favorites"
          "proxymenu": "Proxy list"
          "country"  : "Country"
      ru:
        translation:
          "blacklist": "Чёрный список"
          "favorites": "Избранное"
          "proxymenu": "Список прокси"
          "country"  : "Страна"
      be:
        translation:
          "blacklist": "Чорны спис"
          "favorites": "Абранае"
          "proxymenu": "Списак прокси"
          "country"  : "Краіна"
      uk:
        translation:
          "blacklist": "Чорний список"
          "favorites": "Показати обране"
          "proxymenu": "Список проксі"
          "country"  : "Країна"
      fr:
        translation:
          "blacklist": "La liste noire"
          "favorites": "Les favoris"
          "proxymenu": "La liste de proxies"
          "country"  : "Pays"
      de:
        translation:
          "blacklist": "Schwarze Liste"
          "favorites": "Favoriten anzeigen"
          "proxymenu": "Liste der Proxy"
          "country"  : "Land"
  , () ->
    new Router()

    Backbone.history.start()