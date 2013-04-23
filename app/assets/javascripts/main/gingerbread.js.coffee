#= require webgl-utils
#= require gl-matrix

class BasicShader2D
  constructor: () ->
    @vertex = gl.createShader(gl.VERTEX_SHADER)
    gl.shaderSource(@vertex, """
      attribute vec2 aPosition;
      attribute vec4 aColor;

      uniform mat4 uModelView;
      uniform mat4 uProjection;

      varying vec4 vColor;

      void main(void) {
        gl_PointSize = 3.0;
        gl_Position = uProjection * uModelView * vec4(aPosition, 0.0, 1.0);
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

class VertSeries
  constructor: (shader, init, color) ->
    @shader = shader
    
    @vertices = [ init ]
    num_vertices = 1000
    while @vertices.length < num_vertices
      current_vertex = @vertices[@vertices.length - 1]
      next_vertex = vec2.create()
      next_vertex[0] = 1 - current_vertex[1] + Math.abs(current_vertex[0])
      next_vertex[1] = current_vertex[0]
      @vertices[@vertices.length] = next_vertex

    @vertexBuffer = gl.createBuffer()
    gl.bindBuffer(gl.ARRAY_BUFFER, @vertexBuffer)
    gl.bufferData(gl.ARRAY_BUFFER,
      new Float32Array($.map((Array.apply([], v) for v in @vertices), (n) -> n)),
      gl.STATIC_DRAW)

    @color = color
    @numToRender = 0

  update: () ->
    @numToRender = (@numToRender + 1) % @vertices.length

  render: () ->
    gl.bindBuffer(gl.ARRAY_BUFFER, @vertexBuffer)
    gl.vertexAttribPointer(@shader.positionIndex, 2, gl.FLOAT, false, 0, 0)
    gl.enableVertexAttribArray(@shader.positionIndex)

    gl.vertexAttrib4fv(@shader.colorIndex, Array.apply([], @color))
    gl.disableVertexAttribArray(@shader.colorIndex)

    gl.drawArrays(gl.POINTS, 0, @numToRender)
    # gl.drawArrays(gl.LINE_STRIP, 0, @numToRender)

class Gingerbread
  constructor: (shader) ->
    colors = [
      vec4.clone([ 1.0, 0.0, 0.0, 1.0 ]),
      vec4.clone([ 0.0, 1.0, 0.0, 1.0 ]),
      vec4.clone([ 0.0, 0.0, 1.0, 1.0 ]) ]
    @series = (new VertSeries(shader, vec2.clone([ Math.random()*20.0 - 10.0, Math.random()*20.0 - 10.0 ]), color) for color in colors)
    @shader = shader

  update: () ->
    s.update() for s in @series

  render: (projection, modelView) ->
    gl.useProgram(@shader.program)
    gl.uniformMatrix4fv(@shader.projectionIndex, false, projection)
    gl.uniformMatrix4fv(@shader.modelViewIndex, false, modelView)
    s.render() for s in @series

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

  shaderProgram = new BasicShader2D()
  gb = new Gingerbread(shaderProgram)

  render = () ->
    setTimeout((() -> requestAnimFrame(render)), 100)
    gb.update()
    gl.viewport(0, 0, width, height)
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)

    projection = mat4.create()
    modelView = mat4.create()

    mat4.perspective(projection, Math.PI / 4, width / height,  0.1, 100.0)

    mat4.lookAt(modelView,
      [   0,   0,  30 ],
      [   0,   0,   0 ],
      [   0,   1,   0 ])

    gb.render(projection, modelView)
    gl.flush()
  render()
