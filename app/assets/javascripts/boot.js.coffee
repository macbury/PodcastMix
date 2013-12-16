#= require_tree ./app/templates

$(document).on "pjax:start", ->
  NProgress.start() 
$(document).on "pjax:end", ->
  NProgress.done() 

$(document).ready ->
  $(document).pjax('a', '.main-container')
