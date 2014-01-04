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
  buzzerOnAngle: 90
  buzzerOffAngle: 45
  constructor: ( pin )->
    @pinNum = pin
    @servo = null
    Cylon.robot(
      connection:
        name: 'raspi', adaptor: 'raspi'
      device:
        name: 'servo', driver: 'servo', pin: 3,
      work: ( pi ) =>
        @pi = pi
        @close()
    ).start()

  open: ( length, data )->
    if !@pi
      @notInitialized()
      return 

    if data
      if @lastOpened !== data.lastOpened
        @lastOpened = data.lastOpened
      else 
        console.log('Already opened')
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
      @pi.servo.angle( @buzzerOnAngle )
      setTimeout( =>
        @close()
      , time )

  close: ->
    if !@pi
      @notInitialized()
      return 
    else if @isOpen
      console.log('Closing')
      @isOpen = false
      @pi.servo.angle( @buzzerOffAngle )

    

  notInitialized: ->
    console.log('Servo not initialized')

  getLastOpened: ->
    @lastOpened.getTime()

  getBuzzCount: ->
    @buzzes
