#= require webgl-utils
#= require gl-matrix

class BasicShader
  constructor: () ->
    @vertex = gl.createShader(gl.VERTEX_SHADER)
    gl.shaderSource(@vertex, """
      attribute vec3 aPosition;
      attribute vec4 aColor;

      uniform mat4 uModelView;
      uniform mat4 uProjection;

      varying vec4 vColor;

      void main(void) {
        gl_Position = uProjection * uModelView * vec4(aPosition, 1.0);
        vColor = aColor;
      }
    """)
    gl.compileShader(@vertex)
    if !gl.getShaderParameter(@vertex, gl.COMPILE_STATUS)
      alert("Vertex shader failed to compile: #{gl.getShaderInfoLog(@vertex)}")

    @fragment = gl.createShader(gl.FRAGMENT_SHADER)
    gl.shaderSource(@fragment, """
      precision mediump float;

      varying vec4 vColor;

      void main(void) {
        gl_FragColor = vColor;
      }
    """)
    gl.compileShader(@fragment)
    if !gl.getShaderParameter(@fragment, gl.COMPILE_STATUS)
      alert("Fragment shader failed to compile: #{gl.getShaderInfoLog(@fragment)}")

    @program = gl.createProgram()
    gl.attachShader(@program, @vertex)
    gl.attachShader(@program, @fragment)
    gl.linkProgram(@program)
    if !gl.getProgramParameter(@program, gl.LINK_STATUS)
      alert("Shader program failed to link: #{gl.getProgramInfoLog(shaderProgram)}")

    @positionIndex = gl.getAttribLocation(@program, "aPosition")
    @colorIndex = gl.getAttribLocation(@program, "aColor")
    @modelViewIndex = gl.getUniformLocation(@program, "uModelView")
    @projectionIndex = gl.getUniformLocation(@program, "uProjection")
window.BasicShader = BasicShader


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

    @position = vec3.create([ 0, 0, 0 ])
    @rotation = quat4.create([ 0, 1, 0, 0 ])
    quat4.calculateW(@rotation)

  render: (projectionParam, modelViewParam) ->
    projection = mat4.create(projectionParam)
    modelView = mat4.create(modelViewParam)
    mat4.multiply(modelView, mat4.fromRotationTranslation(@rotation, @position))

    gl.useProgram(@shader.program)

    gl.bindBuffer(gl.ARRAY_BUFFER, @vertexBuffer)
    gl.vertexAttribPointer(@shader.positionIndex, 3, gl.FLOAT, false, 0, 0)
    gl.enableVertexAttribArray(@shader.positionIndex)

    gl.bindBuffer(gl.ARRAY_BUFFER, @colorBuffer)
    gl.vertexAttribPointer(@shader.colorIndex, 4, gl.FLOAT, false, 0, 0)
    gl.enableVertexAttribArray(@shader.colorIndex)

    gl.uniformMatrix4fv(@shader.projectionIndex, false, projection)
    gl.uniformMatrix4fv(@shader.modelViewIndex, false, modelView)
    gl.drawArrays(gl.TRIANGLES, 0, @vertices.length / 3)

window.SphereByRefinement = SphereByRefinement


$(document).ready ->
  canvas = $("#openhf_canvas")
  window.gl = WebGLUtils.setupWebGL(canvas.get(0))

  width = $(window).width()
  height = $(window).height()

  console.debug("width = %o height = %o", width, height)

  canvas.css('position', 'absolute')
  canvas.css('top', '0px')
  canvas.attr('width', width)
  canvas.attr('height', height)

  gl.clearColor(0, 0, 0, 1)
  gl.enable(gl.DEPTH_TEST)

  shaderProgram = new BasicShader()
  sphere = new SphereByRefinement(shaderProgram, 2)

  render = () ->
    requestAnimFrame(render)
    gl.viewport(0, 0, width, height)
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)

    projection = mat4.create()
    modelView = mat4.create()

    mat4.perspective(45, width / height,  0.1, 100.0,  projection)

    mat4.identity(modelView)
    mat4.lookAt(
      [   0,   0,   5 ],
      [   0,   0,   0 ],
      [   0,   1,   0 ],
      modelView)

    sphere.render(projection, modelView)
    gl.flush()
  render()
