# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

gl = null
shaderProgram = null

getShader = (selector) ->
  tag = $(selector)[0]
  if tag.type == "x-shader/x-fragment"
    shader = gl.createShader(gl.FRAGMENT_SHADER)
  else if tag.type == "x-shader/x-vertex"
    shader = gl.createShader(gl.VERTEX_SHADER)
  else
    shader = null

  gl.shaderSource(shader, tag.html())
  gl.compileShader(shader)

  shader

initGL = (canvas) ->
  errorMessage = ""
  gl = canvas.getContext("experimental-webgl")
  gl.viewportWidth = canvas.width
  gl.viewportHeight = canvas.height

initShaders = () ->
  fragmentShader = getShader("#openhf_fragment_shader")
  vertexShader = getShader("#openhf_vertex_shader")

  shaderProgram = gl.createProgram()
  gl.attachShader(shaderProgram, vertexShader)
  gl.attachShader(shaderProgram, fragmentShader)
  gl.linkProgram(shaderProgram)
  gl.useProgram(shaderProgram)

  shaderProgram.vertexPositionAttribute = gl.getAttribLocation(shaderProgram, "aVertexPosition")
  gl.enableVertexAttribArray(shaderProgram.vertexPositionAttribute)
  shaderProgram.pMatrixUniform = gl.getUniformLocation(shaderProgram, "uPMatrix")
  shaderProgram.mvMatrixUniform = gl.getUniformLocation(shaderProgram, "uMVMatrix")

$(document).ready ->
  canvas = $("#openhf_canvas")[0]
  initGL(canvas)
  initShaders()
