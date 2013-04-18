#= require webgl-utils
#= require gl-matrix
#= require main/basic_shader

class SphereByRefinement
  constructor: (@shader, @numRefs) ->
    # Initialize the sphere to be an octohedron.
    @vertices = [
      [  0, -1,  0 ], [  1,  0,  0 ], [  0,  0,  1 ],
      [  0, -1,  0 ], [  0,  0, -1 ], [  1,  0,  0 ],
      [  0, -1,  0 ], [ -1,  0,  0 ], [  0,  0, -1 ],
      [  0, -1,  0 ], [  0,  0,  1 ], [ -1,  0,  0 ],
      [  0,  1,  0 ], [  0,  0,  1 ], [  1,  0,  0 ],
      [  0,  1,  0 ], [  1,  0,  0 ], [  0,  0, -1 ],
      [  0,  1,  0 ], [  0,  0, -1 ], [ -1,  0,  0 ],
      [  0,  1,  0 ], [ -1,  0,  0 ], [  0,  0,  1 ]
    ]

    for i in [0...@numRefs]
      refined_vertices = this.refine(@vertices)
      @vertices = (Array.apply([], v) for v in refined_vertices)

    for v in @vertices
      vec3.normalize(v, v)

    @vertexBuffer = gl.createBuffer()
    gl.bindBuffer(gl.ARRAY_BUFFER, @vertexBuffer)
    gl.bufferData(
      gl.ARRAY_BUFFER,
      new Float32Array($.map(@vertices, (n) -> n)),
      gl.STATIC_DRAW)

    @colors = ([ Math.abs(v[0]), Math.abs(v[1]), Math.abs(v[2]), 1 ] for v in @vertices)
    @colorBuffer = gl.createBuffer()
    gl.bindBuffer(gl.ARRAY_BUFFER, @colorBuffer)
    gl.bufferData(
      gl.ARRAY_BUFFER,
      new Float32Array($.map(@colors, (n) -> n)),
      gl.STATIC_DRAW)

    @position = vec3.clone([ 0, 0, 0 ])
    @rotation = 0.0

  refine: (verts) ->
    tris = ((vec3.clone(v) for v in verts.slice(i, i+3)) for i in [0...verts.length] by 3)
    tri_mps = ([ tri, this.midpoints(tri) ] for tri in tris)
    rv = []
    for tmp in tri_mps
      do (tmp) ->
        rv.push(
          tmp[0][0], tmp[1][0], tmp[1][2],
          tmp[1][0], tmp[0][1], tmp[1][1],
          tmp[1][0], tmp[1][1], tmp[1][2],
          tmp[1][2], tmp[1][1], tmp[0][2])
    rv

  midpoints: (tri) ->
    mp1 = vec3.create()
    mp2 = vec3.create()
    mp3 = vec3.create()
    trivec = (vec3.clone(v) for v in tri)
    [ vec3.lerp(mp1, trivec[0], trivec[1], 0.5),
      vec3.lerp(mp2, trivec[1], trivec[2], 0.5),
      vec3.lerp(mp3, trivec[2], trivec[0], 0.5) ]

  update: () ->
    @rotation += 1.0
    if @rotation >= 360.0
      @rotation = 0.0

  render: (projectionParam, modelViewParam) ->
    projection = mat4.create()
    modelView = mat4.create()
    mat4.copy(projection, projectionParam)
    mat4.copy(modelView, modelViewParam)
    
    mat4.translate(modelView, modelView, @position)
    mat4.rotateY(modelView, modelView, @rotation * Math.PI / 180.0)

    gl.useProgram(@shader.program)

    gl.bindBuffer(gl.ARRAY_BUFFER, @vertexBuffer)
    gl.vertexAttribPointer(@shader.positionIndex, 3, gl.FLOAT, false, 0, 0)
    gl.enableVertexAttribArray(@shader.positionIndex)

    gl.bindBuffer(gl.ARRAY_BUFFER, @colorBuffer)
    gl.vertexAttribPointer(@shader.colorIndex, 4, gl.FLOAT, false, 0, 0)
    gl.enableVertexAttribArray(@shader.colorIndex)

    gl.uniformMatrix4fv(@shader.projectionIndex, false, projection)
    gl.uniformMatrix4fv(@shader.modelViewIndex, false, modelView)
    gl.drawArrays(gl.TRIANGLES, 0, @vertices.length)

window.SphereByRefinement = SphereByRefinement


$(document).ready ->
  canvas = $("#openhf_canvas")
  window.gl = WebGLUtils.setupWebGL(canvas.get(0))

  width = $(window).width()
  height = $(window).height()

  console.debug("width = %o height = %o aspect = %o", width, height, width / height)

  canvas.css('position', 'absolute')
  canvas.css('top', '0px')
  canvas.attr('width', width)
  canvas.attr('height', height)

  gl.clearColor(0, 0, 0, 1)
  gl.enable(gl.DEPTH_TEST)

  shaderProgram = new BasicShader()
  sphere = new SphereByRefinement(shaderProgram, 4)

  render = () ->
    requestAnimFrame(render)
    sphere.update()
    gl.viewport(0, 0, width, height)
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)

    projection = mat4.create()
    modelView = mat4.create()

    mat4.perspective(projection, Math.PI / 4, width / height,  0.1, 100.0)

    mat4.lookAt(modelView,
      [   0,   0,   5 ],
      [   0,   0,   0 ],
      [   0,   1,   0 ])

    sphere.render(projection, modelView)
    gl.flush()
  render()
