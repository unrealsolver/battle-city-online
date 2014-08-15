gulp   = require 'gulp'
gutil  = require 'gulp-util'
coffee = require 'gulp-coffee'
nodemon= require 'gulp-nodemon'
symlink= require 'gulp-sym'
jade   = require 'gulp-jade'
express= require 'express'
config = require './config'

## TODO server.use livereload ...

gulp.task 'client-coffee', ->
  gulp.src(config.clientScriptDir+'**/*.coffee')
    .pipe(coffee())
    .pipe(gulp.dest config.clientBuildDir + '/scripts/')

gulp.task 'client-html', ->
  gulp.src('client/index.html')
    .pipe(gulp.dest config.clientBuildDir)

gulp.task 'client-jade-index', ->
  gulp.src('client/index.jade')
    .pipe(jade())
    .pipe(gulp.dest config.clientBuildDir)

gulp.task 'client-watch', ->
  gulp.watch config.clientScriptDir+'**/*.coffee', ['client-coffee']
  #gulp.watch 'client/index.html', ['client-html']
  gulp.watch 'client/index.jade', ['client-jade-index']

gulp.task 'client-deps', ->
  gulp.src('./bower_components/')
    .pipe(symlink(config.clientBuildDir+'/scripts/components/', force: true))
    .pipe(symlink(config.clientBuildDir+'/styles/components/', force: true))


gulp.task 'nodemon', ->
  nodemon {script: './server/app.js'}

gulp.task 'default', [
  'nodemon', 'client-coffee', 'client-watch', 'client-jade-index', 'client-deps'
]

