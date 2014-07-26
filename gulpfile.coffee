gulp   = require 'gulp'
gutil  = require 'gulp-util'
coffee = require 'gulp-coffee'
nodemon= require 'gulp-nodemon'
express= require 'express'
config = require './config'

serverInstance = null


#app.use express.static config.clientBuildDir
process.env.port = config.port

#server = express()
## TODO server.use livereload ...


gulp.task 'nodemon', ->
  nodemon({script: './server/app.js'})

gulp.task 'default', ['nodemon']

