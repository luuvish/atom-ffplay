ipc = require 'ipc'
remote = require 'remote'

{Model} = require 'theorist'
{$} = require 'space-pen'

module.exports =
class FFplay extends Model
  @version: 1

  @loadOrCreate: (mode) ->
    new this {mode, @version}

  @getCurrentWindow: ->
    remote.getCurrentWindow()

  constructor: ->

  initialize: ->

  getCurrentWindow: ->
    @constructor.getCurrentWindow()

  getWindowDimensions: ->
    browserWindow = @getCurrentWindow()
    [x, y] = browserWindow.getPosition()
    [width, height] = browserWindow.getSize()
    {x, y, width, height}

  setWindowDimensions: ({x, y, width, height}) ->
    if width? and height?
      @setSize width, height
    if x? and y?
      @setPosition x, y
    else
      @center()

  startWindow: ->
    @displayWindow()

  open: (options) ->
    ipc.send 'open', options

  reload: ->
    ipc.send 'call-window-method', 'restart'

  focus: ->
    ipc.send 'call-window-method', 'focus'
    $(window).focus()

  show: ->
    ipc.send 'call-window-method', 'show'

  hide: ->
    ipc.send 'call-window-method', 'hide'

  setSize: (width, height) ->
    ipc.send 'call-window-method', 'setSize', width, height

  setPosition: (x, y) ->
    ipc.send 'call-window-method', 'setPosition', x, y

  center: ->
    ipc.send 'call-window-method', 'center'

  displayWindow: ->
    setImmediate =>
      @show()
      @focus()
      @setFullScreen(false)

  close: ->
    @getCurrentWindow().close()

  exit: (status) ->
    app = remote.require('app')
    app.emit 'will-exit'
    remote.process.exit status

  toggleFullScreen: ->
    @setFullScreen !@isFullScreen()

  setFullScreen: (fullScreen=false) ->
    ipc.send 'call-window-method', 'setFullScreen', fullScreen

  isFullScreen: ->
    @getCurrentWindow().isFullScreen()
