#= require gl-matrix

factory = (func) ->
  (argp) ->
    arg = if argp instanceof Float32Array then argp else argp.internal
    rv = mat3.create()
    new Mat3(func(rv, arg))

scalarUnaryOp = (func) ->
  () ->
    func(@internal)

matrixUnaryOp = (func) ->
  () ->
    rv = mat4.create()
    new Mat4(func(rv, @internal))

matrixBinaryOp = (func) ->
  (other) ->
    rv = mat4.create()
    new Mat4(func(rv, @internal, other.internal))

matrixBinaryOpByScalar = (func) ->
  (s) ->
    rv = mat4.create()
    new Mat4(func(rv, @internal, s))

class Mat4
  constructor: (args) ->
    if args instanceof Float32Array
      @internal = mat4.clone(args)
    else if args instanceof Mat4
      @internal = mat4.clone(args.internal)
    else
      @internal = mat4.create()

  determinant: scalarUnaryOp(mat4.determinant)
  str: scalarUnaryOp(mat4.str)
  
  adjoint: matrixUnaryOp(mat4.adjoint)
  inverse: matrixUnaryOp(mat4.invert)
  invert: matrixUnaryOp(mat4.invert)
  transpose: matrixUnaryOp(mat4.transpose)

  mul: matrixBinaryOp(mat4.multiply)
  multiply: matrixBinaryOp(mat4.multiply)
  scale: matrixBinaryOp(mat4.scale)
  translate: matrixBinaryOp(mat4.translate)

  rotate: matrixBinaryOpByScalar(mat4.rotate)

Mat4.fromRotationTranslation = (qp, vp) ->
  rv = mat4.create()
  q = if qp instanceof Float32Array then qp else qp.internal
  v = if vp instanceof Float32Array then vp else vp.internal
  mat4.fromRotationTranslation(rv, q, v)

Mat4

window.Mat4 = window.M4 = Mat4
