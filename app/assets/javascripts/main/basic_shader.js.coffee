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
