# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

initGL = (canvas) ->
  errorMessage = ""
  gl = WebGLUtils.setupWebGL(canvas)
  gl.viewportWidth = canvas.width;
  gl.viewportHeight = canvas.height;
  gl


initShaders = (gl) ->
  vertexShader = gl.createShader(gl.VERTEX_SHADER)
  gl.shaderSource(vertexShader, """
    attribute vec3 aVertexPosition;
    attribute vec4 aVertexColor;

    uniform mat4 uMVMatrix;
    uniform mat4 uPMatrix;

    // varying vec4 vColor;

    void main(void) {
      gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
      // vColor = aVertexColor;
    }
  """)
  gl.compileShader(vertexShader)
  if !gl.getShaderParameter(vertexShader, gl.COMPILE_STATUS)
    throw "Couldn't compile vertex shader: #{gl.getShaderInfoLog(vertexShader)}"

  fragmentShader = gl.createShader(gl.FRAGMENT_SHADER)
  gl.shaderSource(fragmentShader, """
    precision mediump float;
    // varying vec4 vColor;

    void main(void) {
      // gl_FragColor = vColor;
      gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
    }
  """)
  gl.compileShader(fragmentShader)
  if !gl.getShaderParameter(fragmentShader, gl.COMPILE_STATUS)
    throw "Couldn't compile fragment shader: #{gl.getShaderInfoLog(fragmentShader)}"

  shaderProgram = gl.createProgram()
  gl.attachShader(shaderProgram, vertexShader)
  gl.attachShader(shaderProgram, fragmentShader)
  gl.linkProgram(shaderProgram)
  if !gl.getProgramParameter(shaderProgram, gl.LINK_STATUS)
    throw "Couldn't link shader program: #{gl.getProgramInfoLog(shaderProgram)}"
  gl.useProgram(shaderProgram)

  shaderProgram.vertexPositionAttribute = gl.getAttribLocation(shaderProgram, "aVertexPosition")
  gl.enableVertexAttribArray(shaderProgram.vertexPositionAttribute)

  # shaderProgram.vertexColorAttribute = gl.getAttribLocation(shaderProgram, "aVertexColor")
  # gl.enableVertexAttribArray(shaderProgram.vertexColorAttribute)

  shaderProgram.projectionMatrixUniform = gl.getUniformLocation(shaderProgram, "uMVMatrix")
  shaderProgram.modelViewMatrixUniform = gl.getUniformLocation(shaderProgram, "uPMatrix")

  shaderProgram


initBuffers = (gl) ->
  groundVertexBuffer = gl.createBuffer()
  gl.bindBuffer(gl.ARRAY_BUFFER, groundVertexBuffer)
  groundVertices = [
     1.0,  1.0,  0.0,
    -1.0,  1.0,  0.0,
     1.0, -1.0,  0.0,
    -1.0, -1.0,  0.0
  ]
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(groundVertices), gl.STATIC_DRAW)
  groundVertexBuffer.itemSize = 3
  groundVertexBuffer.numItems = 3

  # groundColorBuffer = gl.createBuffer()
  # gl.bindBuffer(gl.ARRAY_BUFFER, groundColorBuffer)
  # groundColors = [
  #   0.0, 1.0, 0.0, 1.0,
  #   0.0, 1.0, 0.0, 1.0,
  #   0.0, 1.0, 0.0, 1.0,
  #   0.0, 1.0, 0.0, 1.0
  # ]
  # gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(groundColors), gl.STATIC_DRAW)
  # groundColorBuffer.itemSize = 4
  # groundColorBuffer.numItems = 4

  { ground: { vertices: groundVertexBuffer } } # , colors: groundColorBuffer } }


init = (gl) ->
  gl.clearColor(0.0, 0.0, 0.0, 1.0)
  gl.enable(gl.DEPTH_TEST)


pushMatrix = (stack, mat) ->
  copy = mat4.create(mat)
  stack.push(copy)


popMatrix = (stack, mat) ->
  if stack.length == 0
    throw "Empty stack!"
  mat = stack.pop()


drawFrame = (gl, shaderProgram, buffers) ->
  gl.viewport(0, 0, gl.viewportWidth, gl.viewportHeight)
  gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)

  modelView = mat4.create()
  projection = mat4.create()
  modelViewStack = []
  pushMV = () ->
    pushMatrix(modelViewStack, modelView)
  popMV = () ->
    popMatrix(modelViewStack, modelView)
  setUniforms = () ->
    gl.uniformMatrix4fv(shaderProgram.projectionMatrixUniform, false, projection)
    gl.uniformMatrix4fv(shaderProgram.modelViewMatrixUniform, false, modelView)

  mat4.identity(projection)
  mat4.perspective(45.0, gl.viewportWidth / gl.viewportHeight, 0.1, 1000.0, projection)

  mat4.identity(modelView)
  # mat4.lookAt(
  #   [  0.0, 10.0, 10.0 ],
  #   [  0.0,  0.0,  0.0 ],
  #   [  0.0,  0.0,  1.0 ],
  #   modelView)

  pushMV()
  # mat4.scale(modelView, [ 10.0, 10.0, 10.0 ])
  mat4.translate(modelView, [ 0.0, 0.0, -7.0 ])
  groundVertexBuffer = buffers["ground"]["vertices"]
  # groundColorBuffer = buffers["ground"]["colors"]
  gl.bindBuffer(gl.ARRAY_BUFFER, groundVertexBuffer)
  gl.vertexAttribPointer(shaderProgram.vertexPositionAttribute, groundVertexBuffer.itemSize, gl.FLOAT, false, 0, 0)
  # gl.bindBuffer(gl.ARRAY_BUFFER, groundColorBuffer)
  # gl.vertexAttribPointer(shaderProgram.vertexColorAttribute, groundColorBuffer.itemSize, gl.FLOAT, false, 0, 0)
  setUniforms()
  gl.drawArrays(gl.TRIANGLES, 0, groundVertexBuffer.numItems)
  popMV()


updateScene = () ->
  # update the scene here...


mainLoop = (gl, shaderProgram, buffers) ->
  iteration = () ->
    requestAnimFrame(iteration)
    drawFrame(gl, shaderProgram, buffers)
    updateScene()
  iteration()


$(document).ready ->
  canvas = $("#openhf_canvas")[0]
  gl = initGL(canvas)
  shaderProgram = initShaders(gl)
  buffers = initBuffers(gl)
  init(gl)
  mainLoop(gl, shaderProgram, buffers)
