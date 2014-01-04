gpio = require('gpio')
Events = require('events').EventEmitter
Cylon = require('cylon')

module.exports = class Buzzer extends Events
  interval: 200
  buzzes: 0
  lastOpened: new Date()
  isOpen: false
  defaultTime: 5
  maxTime: 15000
  constructor: ( pin )->
    @pinNum = pin
    @servo = null
    Cylon.robot(
      connection:
        name: 'raspi', adaptor: 'raspi'
      device:
        name: 'servo', driver: 'servo', pin: 3,
      work: ( servo ) =>
        @servo = servo
    ).start()

  open: ( length )->
    if !@servo
      @notInitialized()
      return 

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
    if !@servo
      @notInitialized()
      return 
    console.log('Closing')
    @set( 0, =>
      @isOpen = false
    )

  notInitialized: ->
    console.log('Servo not initialized')

  getLastOpened: ->
    @lastOpened.getTime()

  getBuzzCount: ->
    @buzzes
