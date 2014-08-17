renderer = new PIXI.WebGLRenderer 1024, 600
pixiContainer = document.getElementById('pixi-container')
pixiContainer.appendChild(renderer.view)

stats = new Stats()
stats.setMode 0
pixiContainer.appendChild stats.domElement

stage = new PIXI.Stage 0x66FF99

rect = new PIXI.Graphics()
rect.lineStyle 5, 0xFF6F26, 1
rect.drawRect 0, 0, 100, 100
rect.x = 200
rect.y = 200
rect.pivot = new PIXI.Point(50, 50)

stage.addChild rect

animate = ->
  stats.begin()
  rect.rotation += 0.1
  renderer.render stage
  stats.end()
  requestAnimationFrame animate

requestAnimationFrame animate

