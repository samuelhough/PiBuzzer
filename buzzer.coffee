gpio = require('gpio')
_ = require('underscore')
Events = require('events').EventEmitter

module.exports = class Buzzer extends Events
  interval: 200
  buzzes: 0
  lastOpened: new Date()
  isOpen: false
  defaultTime: 5
  maxTime: 15000
  constructor: ( pin )->
    @pinNum = pin
    @gpio = gpio.export( @pinNum,
      
      # When you export a pin, the default direction is out. This allows you to set
      # the pin value to either LOW or HIGH (3.3V) from your program.
      direction: "out"
      
      # set the time interval (ms) between each read when watching for value changes
      # note: this is default to 100, setting value too low will cause high CPU usage
      interval: @interval
      
      # Due to the asynchronous nature of exporting a header, you may not be able to
      # read or write to the header right away. Place your logic in this ready
      # function to guarantee everything will get fired properly
      ready: _.bind( @, @onPinReady )
    )

  onPinReady: ->
    @emit('pin:ready', @gpio.value )

  get: ->
    @gpio.value

  set: ( value, cb )->
    cb = cb or ->
    @gpio.set( value, cb )

  open: ( length )->
    console.log('Trying to open')
    time = Number(length)
    if isNaN(time)
      time = @defaultTime
    if !time
      time = @defaultTime
    
    time *= 1000
    
    if time > @maxTime
      time = @maxTime 

    if !@isOpen
      console.log('Opening for '+time)
      @isOpen = true
      @lastOpened = new Date()
      @buzzes++
      @set( 1 )
      setTimeout( =>
        @close()
      , time )

  close: ->
    console.log('Closing')
    @set( 0, =>
      @isOpen = false
    )

  getLastOpened: ->
    @lastOpened.getTime()

  getBuzzCount: ->
    @buzzes
