class Dashing.Youtube extends Dashing.Widget

  ready: ->
    @player = false
    @playerScreen = $(@node).find(".youtube-container")
    @video_queue = []

  onData: (data) ->
    command = data['command']
    if data.hasOwnProperty('url')
      video_id = @getVideoId(data['url'])
    if video_id
      @video_queue[@video_queue.length] = video_id
      if !@player
        @prepareScreen()
        @showNextVideo()
    else if @player && @validStraightCommand(command)
      @player.tubeplayer command
      @destroyPlayer() if command == 'stop'
    else if @player && command == 'next'
      @showNextVideo()

  validStraightCommand: (command) ->
    valid_commands = ['play', 'pause', 'stop', 'mute', 'unmute']
    return valid_commands.indexOf(command) != -1

  clearQueue: () ->
    @video_queue = []

  destroyPlayer: () ->
    @clearQueue()
    @player.tubeplayer 'destroy'
    @player = false
    @playerScreen.fadeOut()


  getVideoId: (url) ->
    return null  if url.indexOf("?") is -1
    query = decodeURI(url).split("?")[1]
    params = query.split("&")
    i = 0
    l = params.length
    while i < l
      return params[i].replace("v=", "")  if params[i].indexOf("v=") is 0
      i++
    null

  prepareScreen: =>
    @playerScreen.detach()
    $('body').append @playerScreen
    @playerScreen.css
      width: $(window).width()
      height: $(window).height()
    @playerScreen.fadeIn()

  hideScreen: =>
    @playerScreen.fadeOut()

  showNextVideo: =>
    if @video_queue.length > 0
      @video_id = @video_queue.shift()
      if !@player
        @player = $("#youtubeplayer").tubeplayer
          width: $(window).width()
          height: $(window).height()
          initialVideo: @video_id
          autoPlay: true
          theme: "dark"
          showControls: false
          onPlayerEnded: =>
            @showNextVideo()
          onErrorNotFound: =>
            @showNextVideo()
          onErrorNotEmbeddable: =>
            @showNextVideo()
          onErrorInvalidParameter: =>
            @showNextVideo()
      else
        @player.tubeplayer 'play', @video_id
    else
      @player.tubeplayer 'destroy'
      @player = false
      @playerScreen.fadeOut()
