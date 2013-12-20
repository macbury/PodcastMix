#= require_self
#= require_tree ./app/templates
#= require_tree ./app/views

window.Application = {
  Context: {
    Player: null,
    Search: null
  },
  Views: {},
  Models: {}
}

$(document).ready ->
  Application.Context.Search = new Application.Views.SearchView();