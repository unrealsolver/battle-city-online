var express = require('express')
var config  = require('./../config')

var app = express()

app.get('/api', function(req, res) {
  res.send('Just another hello world')
})

config.setupExpress(app)
app.listen(config.port)

