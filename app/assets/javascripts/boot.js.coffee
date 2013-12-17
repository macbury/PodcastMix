#= require_self
#= require_tree ./app/templates
#= require_tree ./app/views

window.Lama = {
  App: null,
  Views: {}
}

Lama.App = new Backbone.Marionette.Application(); 

Lama.App.addRegions
  player: "#player-view"

Lama.App.addInitializer (options) ->
  Backbone.history.start pushState: false
  playerView = new Lama.Views.PlayerView()

$(document).ready -> Lama.App.start()
