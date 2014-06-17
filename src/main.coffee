app = require 'app'
BrowserWindow = require 'browser-window'

require('crash-reporter').start()

mainWindow = null

app.on 'window-all-closed', ->
  app.quit() # if process.platform isnt 'darwin'

app.on 'ready', ->
  mainWindow = new BrowserWindow width: 800, height: 600
  mainWindow.loadUrl "file://#{__dirname}/../static/index.html"
  mainWindow.on 'closed', ->
    mainWindow = null
