gulp   = require 'gulp'
gutil  = require 'gulp-util'
coffee = require 'gulp-coffee'
nodemon= require 'gulp-nodemon'
express= require 'express'
config = require './config'

## TODO server.use livereload ...

gulp.task 'client-coffee', ->
  gulp.src(config.clientScriptDir+'/**/*.coffee')
    .pipe(coffee())
    .pipe(gulp.dest config.clientBuildDir)

gulp.task 'client-html', ->
  gulp.src('client/index.html')
    .pipe(gulp.dest config.clientBuildDir)

gulp.task 'client-watch', ->
  gulp.watch config.clientScriptDir+'**/*.coffee', ['client-coffee']

gulp.task 'nodemon', ->
  nodemon {script: './server/app.js'}

gulp.task 'default', [
  'nodemon', 'client-coffee', 'client-watch', 'client-html'
]

