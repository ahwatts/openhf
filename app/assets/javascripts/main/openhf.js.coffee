#= require webgl-utils
#= require gl-matrix
#= require main/basic_shader

class WorldObject
  constructor: (@world) ->
    @worldPos = vec3.create([ 0, 0, 0 ])
    @worldVelMag = 0.0
    @worldVelDir = vec3.create([ 1, 0, 0 ])
    @angPos = 0.0
    @angVel = 0.0
    @shader = new BasicShader()

  update: (dt) ->
    ds = vec3.create()
    dsMag = dt*@worldVelMag
    vec3.scale(@worldVelDir, dsMag, ds)
    vec3.add(@worldPos, ds)
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
    modelView = mat4.create(@world.modelViewStack[0])
    mat4.translate(modelView, @worldPos)
    mat4.rotateZ(modelView, @angPos)

    gl.useProgram(@shader.program)

    gl.bindBuffer(gl.ARRAY_BUFFER, @vertexBuffer)
    gl.vertexAttribPointer(@shader.positionIndex, 3, gl.FLOAT, false, 0, 0)
    gl.enableVertexAttribArray(@shader.positionIndex)

    gl.vertexAttrib4fv(@shader.colorIndex, new Float32Array(@color))
    gl.disableVertexAttribArray(@shader.colorIndex)

    gl.uniformMatrix4fv(@shader.projectionIndex, false, @world.projection)
    gl.uniformMatrix4fv(@shader.modelViewIndex, false, modelView)
    gl.drawArrays(gl.TRIANGLE_STRIP, 0, @verts.length)

class World
  constructor: () ->
    @projection = mat4.ortho(-100, 100, -100, 100, -1, 1000)

    @modelViewStack = []
    @modelViewStack.push(mat4.lookAt(0, 0, -1, 0, 0, 0, 0, 1, 0))

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
