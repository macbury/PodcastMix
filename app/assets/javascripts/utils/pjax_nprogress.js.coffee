$(document).on "pjax:start", ->
  NProgress.start() 
$(document).on "pjax:end", ->
  NProgress.done() 

$.for = ( selector, cb ) -> cb() if $(selector).size() > 0
$.enter = ( selector, cb ) -> 
  $(document).on "pjax:end", -> $.for(selector, cb)
  $(document).on "initialize", -> $.for(selector, cb)
  
$.exit = ( selector, cb ) -> 
  $(document).on "pjax:start", -> $.for(selector, cb)

$(document).ready ->
  $.main_container = $('.main-container')
  $(document).pjax('a', $.main_container)
  $(document).trigger("initialize")