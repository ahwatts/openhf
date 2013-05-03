#= require webgl-utils
#= require gl-matrix
#= require gl-matrix-wrapper
#= require main/basic_shader

class WorldObject
  constructor: (@world) ->
    @worldPos = vec3.clone([ 0, 0, 0 ])
    @worldVelMag = 0.0
    @worldVelDir = vec3.clone([ 1, 1, 0 ])
    @angPos = 0.0
    @angVel = 0.1
    @shader = new BasicShader()

  update: (dt, mouse) ->
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
    @mass = 500.0

    @vertexBuffer = gl.createBuffer()
    gl.bindBuffer(gl.ARRAY_BUFFER, @vertexBuffer)
    gl.bufferData(
      gl.ARRAY_BUFFER,
      new Float32Array($.map(@verts, (n) -> n)),
      gl.STATIC_DRAW)

  update: (dt, mouse) ->
    [ mn, mf ] = @world.unproject(mouse.x, mouse.y)
    k = 2000.0
    sf = vec3.create()
    ff = vec3.create()
    a = vec3.create()
    v0 = vec3.create()
    v1 = vec3.create()
    x0 = vec3.clone(@worldPos)
    x1 = vec3.create()
    
    vec3.scale(v0, @worldVelDir, @worldVelMag)
    # v0 now holds the initial velocity as a vector.

    # spring: f = k*x
    mn[2] = 0.0
    vec3.subtract(sf, mn, @worldPos)
    vec3.scale(sf, sf, k)

    # friction: f = -c*v^2
    vec3.normalize(ff, v0)
    vec3.scale(ff, ff, -20.0 *vec3.sqrLen(v0))

    vec3.add(a, ff, sf)
    # a now holds the force.

    # a = f/m
    vec3.scale(a, a, 1.0 / @mass)
    # a now holds the acceleration.

    # v1 = v0 + a*dt
    vec3.scaleAndAdd(v1, v0, a, dt)
    # v1 now holds the new velocity.

    # x1 = x0 + v0*dt + (1/2)*a*dt^2
    vec3.scaleAndAdd(x1, x0, v0, dt)
    vec3.scaleAndAdd(x1, x1, a, 0.5*dt*dt)

    @worldPos = x1
    @worldVelMag = vec3.length(v1)
    vec3.normalize(@worldVelDir, v1)

    @angPos = @angPos + @angVel*dt
    @angPos = @angPos - 2*Math.PI if @angPos > 2*Math.PI

    $("#pos").html(vec3.str(@worldPos))
    $("#vel_mag").html(@worldVelMag)
    $("#vel_dir").html(vec3.str(@worldVelDir))

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
  constructor: (width, height) ->
    @projection = mat4.create()
    mat4.ortho(@projection, -100, 100, -100, 100, 0, 10)
    @projectionInverse = mat4.create()
    mat4.invert(@projectionInverse, @projection)
    @width = width
    @height = height

    mv = mat4.create()
    mat4.lookAt(mv, [ 0, 0, 1 ], [ 0, 0, 0 ], [ 0, 1, 0 ])
    @modelViewStack = [ mv ]
    @modelViewInverse = mat4.create()
    mat4.invert(@modelViewInverse, @modelViewStack[0])

    @objects = []

  update: (dt, mouse) ->
    for object in @objects
      object.update(dt, mouse)
    [ mNear, mFar ] = this.unproject(mouse.x, mouse.y)
    $("#mouse_near").html(vec3.str(mNear))
    $("#mouse_far").html(vec3.str(mFar))

  render: () ->
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
    gl.viewport(0, 0, @width, @height)
    @modelViewStack.unshift() while @modelViewStack.length > 1

    for object in @objects
      object.render()

    gl.flush()

  unproject: (winX, winY) ->
    viewX =  2 * (winX / @width) - 1
    viewY = -2 * (winY / @height) + 1
    winNear = vec3.fromValues(viewX, viewY, 0.0)
    winFar = vec3.fromValues(viewX, viewY, 1.0)
    mvpInverse = mat4.create()
    mat4.multiply(mvpInverse, @modelViewInverse, @projectionInverse)
    worldNear = vec3.create()
    worldFar = vec3.create()
    vec3.transformMat4(worldNear, winNear, mvpInverse)
    vec3.transformMat4(worldFar, winFar, mvpInverse)
    [ worldNear, worldFar ]

class Mouse
  constructor: (x, y) ->
    this.setPosition(x, y)

  positionVec: () ->
    vec3.clone([ @x, @y, 0.0 ])

  setPosition: (x, y) ->
    @x = x
    @y = y
    $("#mouse_pos").html("(" + @x + ", " + @y + ")")

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

  world = new World(width, height)
  world.objects.unshift(new Flyer(world))
  mouse = new Mouse(0, 0)

  $('body').mousemove((event) ->
    mouse.setPosition(event.pageX, event.pageY))

  render = () ->
    setTimeout((() -> requestAnimFrame(render)), 32)
    world.update(0.032, mouse)
    world.render()
  render()
