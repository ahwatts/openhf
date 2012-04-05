#= require webgl-utils
#= require gl-matrix

class World
  constructor: () ->
    @projection = mat4.ortho(-100, 100, -100, 100, 0, 1000)

    @modelViewStack = []
    @modelViewStack.push(mat4.lookAt(0, 0, -1, 0, 0, 0, 0, 1, 0))

    @objects = []

  update: () ->
    # Nothing here...

  render: () ->
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
    @modelViewStack.pop() while @modelViewStack.length > 1

    for object in @objects
      object.render()

    gl.flush()

window.World = World

$(document).ready ->
  canvas = $('canvas#openhf')
  window.gl = WebGLUtils.setupWebGL(canvas.get(0))

  width = $(window).width()
  height = $(window).height()

  canvas.css('position', 'absolute')
  canvas.css('top', '0px')
  canvas.attr('width', width)
  canvas.attr('height', height)

  gl.clearColor(0, 0, 0, 1)
  gl.enable(gl.DEPTH_TEST)

  world = new World()

  render = () ->
    requestAnimFrame(render)
    world.update()
    world.render()
  render()
