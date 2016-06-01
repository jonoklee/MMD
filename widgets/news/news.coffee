class Dashing.News extends Dashing.Widget

  ready: ->
    @currentIndex = -1
    @headlineElem = $(@node).find('.headline-container')
    @nextComment()
    @startCarousel()

  onData: (data) ->
    @currentIndex = -1

  startCarousel: ->
    interval = $(@node).attr('data-interval')
    interval = "30" if not interval
    setInterval(@nextComment, parseInt( interval ) * 1000)

  nextComment: =>
    headlines = @get('headlines')
    if headlines
      @headlineElem.fadeOut =>
        @currentIndex = (@currentIndex + 1) % headlines.length
        @set 'current_headline', headlines[@currentIndex]
        @set 'current_image', headlines[@currentIndex].image
        @headlineElem.fadeIn()
