Buzzer  = require('./buzzer')
Led     = require('./led')
Manager = require('./manager')
express = require('express')
ip      = require('./ip')

manager = new Manager()
buzzer = new Buzzer()
led    = new Led()
app    = express()
port   = 81
start_time   = new Date()
server_time  = new Date()
current_time = new Date()
lastOpened   = new Date()
lastOpenedBy = ""
buzz_count   = 0

getStats = ->
  cTime = new Date()
  {
    start_time: start_time
    alive_for: ( ( cTime.getTime() - start_time.getTime() ) / 1000 / 60 / 60 ) + " hours"
    buzz_count: buzzer.getBuzzCount()
    last_opened: lastOpened
    last_opened_by: lastOpenedBy
    current_time: current_time.getTime()
    server_time: server_time.getTime()
  }

routes = require('./routes')( app, getStats, express )

manager.on('json:data', ( data )->
  led.blink()
  server_time = new Date( data.current_time )
  if( data.door_open is true )
    buzzer.open( data.open_for, data )
)

console.log(ip.ip+ ' listening on port: '+ port )
manager.initialize()
app.listen( port )