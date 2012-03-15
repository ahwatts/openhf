#= require webgl-utils
#= require gl-matrix

$(document).ready ->
  canvas = $("#openhf_canvas")
  gl = WebGLUtils.setupWebGL(canvas.get(0))
