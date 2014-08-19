renderer = new PIXI.WebGLRenderer 1024, 600
pixiContainer = document.getElementById('pixi-container')
pixiContainer.appendChild(renderer.view)

stats = new Stats()
stats.setMode 0
pixiContainer.appendChild stats.domElement

stage = new PIXI.Stage 0xefefff

player = new PIXI.DisplayObjectContainer()
player.xchildren =
  body: do ->
    g = new PIXI.Graphics()
    g.lineStyle 5, 0xFF6F26, .8
    g.drawRect 0, 0, 50, 50
    #g.pivot = new PIXI.Point 25, 25
    #g.x = 25
    #g.y = 25
    g
  gun: do ->
    g = new PIXI.Graphics()
    g.lineStyle 4, 0x1F4FE4, .8
    g.drawRect 22, 20, 6, -52
    #g.pivot = new PIXI.Point 25, 25
    #g.x = 25
    #g.y = 25
    g
player.addChild player.xchildren.body
player.addChild player.xchildren.gun
player.x = 500
player.y = 300
player.pivot = x: 25, y: 25
player.xv = 5
player.xdirection = 0
player.xshoot = ->
  spawnProjectile @x, @y, @rotation
player.xupdate = ->
  @rotation = @xdirection * Math.PI / 2
stage.addChild player

spawnProjectile = (x, y, rot) ->
  projectile = new PIXI.DisplayObjectContainer()
  projectile.xchildren =
    ball: do ->
      g = new PIXI.Graphics()
      g.lineStyle 4, 0x222222, 1
      g.drawCircle 0, 0, 6
  projectile.addChild projectile.xchildren.ball
  projectile.x = x
  projectile.y = y
  projectile.rotation = rot
  projectile.xspd = 10
  projectile.xv =
    x: projectile.xspd * Math.sin rot
    y: projectile.xspd * -Math.cos rot
  projectile.xupdate = ->
    @x += @xv.x
    @y += @xv.y
    _.each stage.children, (d) =>
      if d.xcollide && d.xcollide == 'rect'
        if d.x < @x < d.x + d.xwidth and d.y < @y < d.y + d.xheight
          @xOnHit()

  projectile.xcollide = 'dot'
  projectile.xOnHit = ->
    stage.removeChild @
    spawnExplosion @x, @y
  stage.addChild projectile

kd.SPACE.press ->
  player.xshoot()

block = new PIXI.DisplayObjectContainer()
block.xchildren =
  box: do ->
    g = new PIXI.Graphics()
    g.lineStyle 2, 0x777777, .8
    g.drawRect 0, 0, 100, 100
    g
block.addChild block.xchildren.box
_.extend block, {
  x: 500
  y: 60
  xwidth: 100
  xheight: 100
  xcollide: 'rect'
}
stage.addChild block

spawnExplosion = (x, y) ->
  container = new PIXI.DisplayObjectContainer()
  _.extend container, {
    x: x
    y: y
    xttl: 30
  }
  container.xSpawnFog = (x, y) ->
    @addChild do ->
      g = new PIXI.Graphics()
      g.lineStyle 2, 0, 1
      g.drawRect 0, 0, 10, 10
      g.pivot = x: 5, y: 5
      g.x = x
      g.y = y
      g.rotation = Math.random()
      g
  container.xupdate = ->
    if @xttl-- > 0
      revTtl = 30 - @xttl
      if @xttl % 3
        @xSpawnFog _.random(-revTtl, revTtl), _.random(-revTtl, revTtl)
        @alpha = @xttl / 30
    else
      stage.removeChild @
  stage.addChild container


animate = ->
  stats.begin()

  if kd.UP.isDown()
    player.y -= player.xv
    player.xdirection = 0
  if kd.DOWN.isDown()
    player.y += player.xv
    player.xdirection = 2
  if kd.LEFT.isDown()
    player.x -= player.xv
    player.xdirection = 3
  if kd.RIGHT.isDown()
    player.x += player.xv
    player.xdirection = 1

  _.each stage.children, (d) -> d.xupdate?()

  renderer.render stage
  
  stats.end()
  requestAnimationFrame animate

requestAnimationFrame animate

