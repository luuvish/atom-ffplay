startTime = Date.now()

FFplay = require './ffplay'
window.ffplay = FFplay.loadOrCreate('ffplay')
ffplay.initialize()
ffplay.startWindow()

console.log "Window load time: #{Date.now() - startTime}ms"
