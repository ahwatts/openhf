#= require webgl-utils
#= require gl-matrix

$(document).ready ->
  canvas = $("#openhf_canvas")
  gl = WebGLUtils.setupWebGL(canvas.get(0))

  width = $(window).width()
  height = $(window).height()

  console.debug("width = %o height = %o", width, height)

  canvas.css('position', 'absolute')
  canvas.css('top', '0px')
  canvas.attr('width', width)
  canvas.attr('height', height)

  gl.clearColor(0, 0, 0, 1)
  gl.enable(gl.DEPTH_TEST)

  vertexShader = gl.createShader(gl.VERTEX_SHADER)
  gl.shaderSource(vertexShader, """
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
  gl.compileShader(vertexShader)
  if !gl.getShaderParameter(vertexShader, gl.COMPILE_STATUS)
    alert("Vertex shader failed to compile: #{gl.getShaderInfoLog(vertexShader)}")

  fragmentShader = gl.createShader(gl.FRAGMENT_SHADER)
  gl.shaderSource(fragmentShader, """
    precision mediump float;

    varying vec4 vColor;

    void main(void) {
      gl_FragColor = vColor;
    }
  """)
  gl.compileShader(fragmentShader)
  if !gl.getShaderParameter(fragmentShader, gl.COMPILE_STATUS)
    alert("Fragment shader failed to compile: #{gl.getShaderInfoLog(fragmentShader)}")

  shaderProgram = gl.createProgram()
  gl.attachShader(shaderProgram, vertexShader)
  gl.attachShader(shaderProgram, fragmentShader)
  gl.linkProgram(shaderProgram)
  if !gl.getProgramParameter(shaderProgram, gl.LINK_STATUS)
    alert("Shader program failed to link: #{gl.getProgramInfoLog(shaderProgram)}")

  positionIndex = gl.getAttribLocation(shaderProgram, "aPosition")
  colorIndex = gl.getAttribLocation(shaderProgram, "aColor")
  modelViewIndex = gl.getUniformLocation(shaderProgram, "uModelView")
  projectionIndex = gl.getUniformLocation(shaderProgram, "uProjection")

  positions = [
     0.0,  1.0,  0.0,
    -1.0, -1.0,  0.0,
     1.0, -1.0,  0.0
  ]
  positionsBuffer = gl.createBuffer()
  gl.bindBuffer(gl.ARRAY_BUFFER, positionsBuffer)
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(positions), gl.STATIC_DRAW)

  colors = [
    1.0, 0.0, 0.0, 1.0,
    0.0, 1.0, 0.0, 1.0,
    0.0, 0.0, 1.0, 1.0
  ]
  colorsBuffer = gl.createBuffer()
  gl.bindBuffer(gl.ARRAY_BUFFER, colorsBuffer)
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(colors), gl.STATIC_DRAW)

  projection = mat4.create()
  modelView = mat4.create()

  render = () ->
    requestAnimFrame(render)
    gl.viewport(0, 0, width, height)
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)

    mat4.perspective(45, width / height,  0.1, 100.0,  projection)

    mat4.identity(modelView)
    mat4.lookAt(
      [   0,   0,   5 ],
      [   0,   0,   0 ],
      [   0,   1,   0 ],
      modelView)

    gl.useProgram(shaderProgram)
    gl.bindBuffer(gl.ARRAY_BUFFER, positionsBuffer)
    gl.vertexAttribPointer(positionIndex, 3, gl.FLOAT, false, 0, 0)
    gl.enableVertexAttribArray(positionIndex)
    gl.bindBuffer(gl.ARRAY_BUFFER, colorsBuffer)
    gl.vertexAttribPointer(colorIndex, 4, gl.FLOAT, false, 0, 0)
    gl.enableVertexAttribArray(colorIndex)
    gl.uniformMatrix4fv(projectionIndex, false, projection)
    gl.uniformMatrix4fv(modelViewIndex, false, modelView)
    gl.drawArrays(gl.TRIANGLES, 0, 3)
    gl.flush()
  render()
