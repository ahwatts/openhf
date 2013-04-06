#= require webgl-utils
#= require gl-matrix
#= require main/basic_shader

class WorldObject
  constructor: (@world) ->
    @worldPos = vec3.clone([ 0, 0, 0 ])
    @worldVelMag = 1.0
    @worldVelDir = vec3.clone([ 1, 1, 0 ])
    @angPos = 0.0
    @angVel = 0.0
    @shader = new BasicShader()

  update: (dt) ->
    dsMag = dt*@worldVelMag
    vec3.scaleAndAdd(@worldPos, @worldPos, @worldVelDir, dsMag)
    @angPos = @angPos + @angVel*dt
    @angPos = @angPos - 2*Math.PI if @angPos > 2*Math.PI

class Flyer extends WorldObject
  constructor: (world) ->
    super(world)
    @verts = [
      [ -1,  1, 0 ],
      [ -1, -1, 0 ],
      [  1,  1, 0 ],
      [  1, -1, 0 ]
    ]
    @color = [ 1, 1, 0, 1 ]

    @vertexBuffer = gl.createBuffer()
    gl.bindBuffer(gl.ARRAY_BUFFER, @vertexBuffer)
    gl.bufferData(
      gl.ARRAY_BUFFER,
      new Float32Array($.map(@verts, (n) -> n)),
      gl.STATIC_DRAW)

  render: () ->
    modelView = mat4.clone(@world.modelViewStack[0])
    mat4.translate(modelView, modelView, @worldPos)
    mat4.rotateZ(modelView, modelView, @angPos)

    gl.useProgram(@shader.program)
    gl.enableVertexAttribArray(@shader.positionIndex)
    gl.disableVertexAttribArray(@shader.colorIndex)

    gl.bindBuffer(gl.ARRAY_BUFFER, @vertexBuffer)
    gl.vertexAttribPointer(@shader.positionIndex, 3, gl.FLOAT, false, 0, 0)

    gl.vertexAttrib4fv(@shader.colorIndex, @color)

    gl.uniformMatrix4fv(@shader.projectionIndex, false, @world.projection)
    gl.uniformMatrix4fv(@shader.modelViewIndex, false, modelView)
    gl.drawArrays(gl.TRIANGLE_STRIP, 0, @verts.length)

class World
  constructor: () ->
    @projection = mat4.create()
    mat4.ortho(@projection, -100, 100, -100, 100, -1, 1000)

    mv = mat4.create()
    mat4.lookAt(mv, [ 0, 0, -1 ], [ 0, 0, 0 ], [ 0, 1, 0 ])
    @modelViewStack = [ mv ]

    @objects = []

  update: (dt) ->
    for object in @objects
      object.update(dt)

  render: () ->
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
    @modelViewStack.unshift() while @modelViewStack.length > 1

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
  world.objects.unshift(new Flyer(world))

  render = () ->
    requestAnimFrame(render)
    world.update(0.1)
    world.render()
  render()
