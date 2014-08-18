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
  projectile.xspd = 15
  projectile.xv =
    x: projectile.xspd * Math.sin rot
    y: projectile.xspd * -Math.cos rot
  projectile.xupdate = ->
    @x += @xv.x
    @y += @xv.y
  stage.addChild projectile

kd.SPACE.press ->
  player.xshoot()

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

  _.each stage.children, (d) -> d.xupdate()

  renderer.render stage
  
  stats.end()
  requestAnimationFrame animate

requestAnimationFrame animate

