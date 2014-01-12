_ = require('underscore')
Events = require('events').EventEmitter
config = require('./config')
Socket = require('socket.io-client')


module.exports = class Manager extends Events
  url: config.url
  reconnects: 0
  heartbeatInterval: 1500
  constructor: ->
    console.log( @url )
    @socket = Socket.connect( @url )
    @socket.on('connect', =>
      console.log('connected')
      @setupHeartbeat()
    );
    @socket.on('disconnect', =>
      console.log('disconnected')
      @clearHeartbeat()
    )
    @socket.on('reconnect', =>
      console.log('reconnected')
      @reconnects++
      @setupHeartbeat()
    )
    @socket.on('data:buzzer', ( data )=>
      console.log( "data received" )
      @emit( 'json:data', data )
    )
    
  clearHeartbeat: ->
    if @heartbeat
      clearInterval( @heartbeat )

  setupHeartbeat: ->
    @clearHeartbeat()
    @heartbeat = setInterval( =>
      console.log('beat...')
      @socket.emit( 'heartbeat', 1 )
    , @heartbeatInterval )

  
    