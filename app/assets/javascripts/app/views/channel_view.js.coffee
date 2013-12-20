ChannelSelector = ".channel.show"

class Application.Views.ChannelView extends Backbone.View
  el: ChannelSelector
  events:
    "ab-color-found .channel-big-poster": "adaptLook"

  adaptLook: (event, payload) =>
    console.log payload
    $('.background-wrapper').css "background-color": payload.color

  initialize: =>
    @channelImg = @$(".channel-big-poster")
    $.adaptiveBackground.run({
      parent: "1",
      selector: @channelImg
    })

  dispose: =>
    @remove()
    $('.background-wrapper').removeAttr("style")    


$.enter ChannelSelector, ->
  Application.Context.ChannelView = new Application.Views.ChannelView()

$.exit ChannelSelector, ->
  Application.Context.ChannelView.dispose() if Application.Context.ChannelView?
  Application.Context.ChannelView = null
