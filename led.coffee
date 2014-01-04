Events = require('events').EventEmitter
Cylon = require('cylon')

module.exports = class Led extends Events
  delay: 100
  constructor: ( pin )->
    Cylon.robot(
      connection:
        name: 'raspi', adaptor: 'raspi'
      device:
        name: 'led', driver: 'led', pin: 8
      work: ( pi ) =>
        @pi = pi
    ).start()

  blink: ->
    @toggle()
    setTimeout( =>
      @toggle()
    , @delay )

  toggle: ->
    if @pi
      @pi.led.toggle()