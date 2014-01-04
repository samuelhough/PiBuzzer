_ = require('underscore')
Events = require('events').EventEmitter
request = require('request');
config = require('./config')

module.exports = class Manager extends Events
  url: config.url
  interval: 2000
  constructor: ->

  initialize: ->
    @delayedFetch()

  delayedFetch: ->
    setTimeout( =>
      @fetchData()
    , @interval )

  fetchData: ( cb )->
    console.log('Fetching data');
    request( @url,  ( error, response, body )=>
      if (!error && response.statusCode == 200)
        try 
          data = JSON.parse(body)
          console.log( data )
          @emit( 'json:data', data )
        catch e 
          console.log( e )
        finally
          @delayedFetch()
      else
        console.log( @url + " is not valid url" )
    )
