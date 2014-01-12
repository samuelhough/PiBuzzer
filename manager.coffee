_ = require('underscore')
Events = require('events').EventEmitter
Socket = require('socket.io-client')
config = require('./config')


module.exports = class Manager extends Events
  url: config.url
  reconnects: 0
  constructor: ->
    @socket = Socket()
    @socket.on('connect', =>
      @onConnectionSetup()
    );
    @socket.on('disconnect', =>
      @clearHeartbeat()
    )
    @socket.on('reconnect', =>
      @reconnects++
      @setupHeartbeat()
    )
    @socket.connect( @url );

  onConnectionSetup: ->
    @socket.on('data:buzzer', =>
      @onDataReceived.apply( @, arguments )
    )
    @setupHeartbeat()

  clearHeartbeat: ->
    if @heartbeat
      clearInterval( @heartbeat )

  setupHeartbeat: ->
    @clearHeartbeat()
    @heartbeat = setInterval( =>
      @socket.emit( 'heartbeat', 1 )
    )

  onDataReceived: ( data )->
    @emit( 'json:data', data )
    