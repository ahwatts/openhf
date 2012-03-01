# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

VERTEX_SHADER_SOURCE = """
    attribute vec3 aVertexPosition;
    attribute vec4 aVertexColor;

    uniform mat4 uMVMatrix;
    uniform mat4 uPMatrix;

    void main(void) {
      gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
      vColor = aVertexColor;
    }
"""

FRAGMENT_SHADER_SOURCE = """
    precision mediump float;
    varying vec4 vColor

    void main(void) {
      gl_FragColor = vColor;
    }
"""

initGL = (canvas) ->
  errorMessage = ""
  gl = canvas.getContext("experimental-webgl")
  gl.viewportWidth = canvas.width;
  gl.viewportHeight = canvas.height;
  gl


initShaders = (gl) ->
  vertexShader = gl.createShader(gl.VERTEX_SHADER)
  gl.shaderSource(vertexShader, VERTEX_SHADER_SOURCE)
  gl.compileShader(vertexShader)

  fragmentShader = gl.createShader(gl.FRAGMENT_SHADER)
  gl.shaderSource(fragmentShader, FRAGMENT_SHADER_SOURCE)
  gl.compileShader(fragmentShader)

  shaderProgram = gl.createProgram()
  gl.attachShader(shaderProgram, vertexShader)
  gl.attachShader(shaderProgram, fragmentShader)
  gl.linkProgram(shaderProgram)
  gl.useProgram(shaderProgram)

  shaderProgram.vertexPositionAttribute = gl.getAttribLocation(shaderProgram, "aVertexPosition")
  gl.enableVertexAttribArray(shaderProgram.vertexPositionAttribute)

  shaderProgram.vertexColorAttribute = gl.getAttribLocation(shaderProgram, "aVertexColor")
  gl.enableVertexAttribArray(shaderProgram.vertexColorAttribute)

  shaderProgram.projectionMatrixAttribute = gl.getUniformLocation(shaderProgram, "uMVMatrix")
  shaderProgram.modelViewMatrixAttribute = gl.getUniformLocation(shaderProgram, "uPMatrix")

  shaderProgram


initBuffers = (gl) ->
  groundVertexBuffer = gl.createBuffer()
  gl.bindBuffer(gl.ARRAY_BUFFER, groundVertexBuffer)
  groundVertices = [
     1.0,  1.0,  0.0,
     1.0, -1.0,  0.0,
    -1.0,  1.0,  0.0,
    -1.0, -1.0,  0.0
  ]
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(groundVertices), gl.STATIC_DRAW)
  groundVertexBuffer.itemSize = 3
  groundVertexBuffer.numItems = 4

  groundColorBuffer = gl.createBuffer()
  gl.bindBuffer(gl.ARRAY_BUFFER, groundColorBuffer)
  groundColors = [
    0.0, 0.5, 0.0, 1.0,
    0.0, 0.0, 0.5, 1.0,
    0.5, 0.0, 0.0, 1.0,
    0.5, 0.5, 0.5, 1.0
  ]
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(groundColors), gl.STATIC_DRAW)
  groundColorBuffer.itemSize = 3
  groundColorBuffer.numItems = 4

  { ground: { vertices: groundVertexBuffer, colors: groundColorBuffer } }


$(document).ready ->
  canvas = $("#openhf_canvas")[0]
  gl = initGL(canvas)
  shaderProgram = initShaders(gl)
  buffers = initBuffers(gl)
