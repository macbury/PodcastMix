class Application.Views.SearchView extends Backbone.View
  el: "#search-view"

  events:
    "keyup  input.search-field": "onSearch"
    "submit form": "onSubmitSearch"

  initialize: =>
    console.log "initialized search"
    @form       = $(@el).find("form")
    @queryInput = @$("input.search-field")
    $(document).on 'pjax:complete', => @queryInput.focus()
  
  onSearch: =>
    clearTimeout(@timer) if @timer?
    @timer = setTimeout(@startSearch, 1500)

  onSubmitSearch: (e) =>
    e.preventDefault()
    @startSearch()

  startSearch: =>
    clearTimeout(@timer) if @timer?

    if @queryInput.val().length > 3
      $.pjax({
        container: $.main_container
        url:       @form.attr("action"),
        data:      @form.serialize()
      });
