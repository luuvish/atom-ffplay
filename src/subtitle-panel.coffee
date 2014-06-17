{View} = require 'space-pen'

module.exports =
class SubtitlePanel extends View
  @version: 1

  @content: ->
    @div class: 'subtitle-panel', tabindex: -1, =>
      @div class: 'border', outlet: 'box', =>
        @div class: 'pane', outlet: 'pane'

  initialize: ->
    @on 'core:subtitle', =>
    @on 'core:show', =>
