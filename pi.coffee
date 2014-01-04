Buzzer = require('buzzer')
Manager = require('./manager')
express = require('express');
buzzer = new Buzzer()
app = express();
port = 80

app.configure(->
  app.use( ( req, res, next )->
    console.log('%s %s', req.method, req.url);
    next();
  )
  app.use( express.static( __dirname + '/public' ) );
);


buzz_count = 0
start_time = new Date()
server_time = new Date()
current_time = new Date()


app.get( '/stats', ( req, res )->
  current_time = new Date()
  res.json( {
    start_time: start_time
    alive_for: ( ( start_time.getTime() ) / 1000 / 60 / 60 ) + " hours"
    buzz_count: buzzer.getBuzzCount()
    last_opened: lastOpened
    last_opened_by: lastOpenedBy
    current_time: current_time.getTime()
    server_time: server_time.getTime()
  } );
  res.end()
)

app.get( '/open', ( req, res )->
  buzzer.open()
)


lastOpened = new Date()
lastOpenedBy = ""
manager = new Manager()
manager.initialize()
manager.on('json:data', ( data )->
  server_time = new Date( data.current_time )
  if( data.door_open is true and buzzer.getLastOpened() < data.last_opened )
    buzzer.open( data.open_for )
)

ip = require('./ip')
console.log(ip.ip);
console.log('Server listening on port '+ port )
app.listen( port );