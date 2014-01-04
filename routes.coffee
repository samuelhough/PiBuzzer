module.exports = ( app, getStats, express )->
  app.configure(->
    app.use( ( req, res, next )->
      console.log('%s %s', req.method, req.url);
      next();
    )
    app.use( express.static( __dirname + '/public' ) );
  );

  app.get( '/stats', ( req, res )->
    current_time = new Date()
    res.json( getStats() );
    res.end()
  )

  app.get( '/open', ( req, res )->
    buzzer.open(  )
    res.json( getStats() )
    res.end()
  )

  app.get( '/close', ( req, res )->
    buzzer.close( )
    res.json(getStats())
    res.end()
  )
  return { routes: true }