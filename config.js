var express = require('express')

var config = {
  port: 3000,
  serverBuildDir: '.server-build/',
  clientBuildDir: '.client-build/',
  clientScriptDir: 'client/scripts/',
  clientViewDir: 'client/views/',
}

module.exports = config

module.exports.setupExpress = function(app) {
  //TBD seitch env
  app.use(express.static(config.clientBuildDir))
}

