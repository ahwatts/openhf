# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

initGL = (canvas) ->
  window.gl = WebGLUtils.setupWebGL(canvas)
  gl.viewportWidth = canvas.width
  gl.viewportHeight = canvas.height


getShader = (gl, id) ->
  shaderScript = document.getElementById(id)
  if !shaderScript
    return null

  str = ""
  k = shaderScript.firstChild
  while k
    if k.nodeType == 3
      str += k.textContent
    k = k.nextSibling

  shader = null
  if shaderScript.type == "x-shader/x-fragment"
    shader = gl.createShader(gl.FRAGMENT_SHADER)
  else if shaderScript.type == "x-shader/x-vertex"
    shader = gl.createShader(gl.VERTEX_SHADER)
  else
    return null

  gl.shaderSource(shader, str)
  gl.compileShader(shader)

  if !gl.getShaderParameter(shader, gl.COMPILE_STATUS)
    alert(gl.getShaderInfoLog(shader))
    return null

  return shader


initShaders = () ->
  fragmentShader = getShader(gl, "shader-fs")
  vertexShader = getShader(gl, "shader-vs")

  window.shaderProgram = gl.createProgram()
  gl.attachShader(shaderProgram, vertexShader)
  gl.attachShader(shaderProgram, fragmentShader)
  gl.linkProgram(shaderProgram)

  if !gl.getProgramParameter(shaderProgram, gl.LINK_STATUS)
    alert("Could not initialise shaders")

  gl.useProgram(shaderProgram)

  shaderProgram.vertexPositionAttribute = gl.getAttribLocation(shaderProgram, "aVertexPosition")
  gl.enableVertexAttribArray(shaderProgram.vertexPositionAttribute)

  shaderProgram.pMatrixUniform = gl.getUniformLocation(shaderProgram, "uPMatrix")
  shaderProgram.mvMatrixUniform = gl.getUniformLocation(shaderProgram, "uMVMatrix")


$(document).ready ->
  canvas = $("#lesson01-canvas")
  initGL(canvas.get(0))
  initShaders()
  initBuffers()

  gl.clearColor(0.0, 0.0, 0.0, 1.0)
  gl.enable(gl.DEPTH_TEST)

  drawScene()
