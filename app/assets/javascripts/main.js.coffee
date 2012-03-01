# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

GL = null
SHADER_PROGRAM = null

VERTEX_SHADER_SOURCE = """
    attribute vec3 aVertexPosition;

    uniform mat4 uMVMatrix;
    uniform mat4 uPMatrix;

    void main(void) {
      gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
    }
"""

FRAGMENT_SHADER_SOURCE = """
    precision mediump float;

    void main(void) {
      gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
    }
"""

initGL = (canvas) ->
  errorMessage = ""
  GL = canvas.getContext("experimental-webgl")
  GL.viewportWidth = canvas.width
  GL.viewportHeight = canvas.height


initShaders = () ->
  vertexShader = GL.createShader(GL.VERTEX_SHADER)
  GL.shaderSource(vertexShader, VERTEX_SHADER_SOURCE)
  GL.compileShader(vertexShader)

  fragmentShader = GL.createShader(GL.FRAGMENT_SHADER)
  GL.shaderSource(fragmentShader, FRAGMENT_SHADER_SOURCE)
  GL.compileShader(fragmentShader)

  SHADER_PROGRAM = GL.createProgram()
  GL.attachShader(SHADER_PROGRAM, vertexShader)
  GL.attachShader(SHADER_PROGRAM, fragmentShader)
  GL.linkProgram(SHADER_PROGRAM)
  GL.useProgram(SHADER_PROGRAM)

  SHADER_PROGRAM.vertexPositionAttribute = GL.getAttribLocation(SHADER_PROGRAM, "aVertexPosition")
  GL.enableVertexAttribArray(SHADER_PROGRAM.vertexPositionAttribute)

  SHADER_PROGRAM.pMatrixUniform = GL.getUniformLocation(SHADER_PROGRAM, "uPMatrix")
  SHADER_PROGRAM.mvMatrixUniform = GL.getUniformLocation(SHADER_PROGRAM, "uMVMatrix")


$(document).ready ->
  canvas = $("#openhf_canvas")[0]
  initGL(canvas)
  initShaders()
