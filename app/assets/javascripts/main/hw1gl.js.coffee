#= require webgl-utils
#= require gl-matrix

$(document).ready ->
  canvas = $("#openhf_canvas")

  canvas.css('position', 'absolute')
  canvas.css('top', '0px')
  canvas.width(window.innerWidth)
  canvas.height(window.innerHeight)
  gl = WebGLUtils.setupWebGL(canvas.get(0))

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
