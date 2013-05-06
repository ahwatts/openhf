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
    rv = mat3.create()
    new Mat3(func(rv, @internal))

matrixBinaryOp = (func) ->
  (other) ->
    rv = mat3.create()
    new Mat3(func(rv, @internal, other.internal))

matrixBinaryOpByScalar = (func) ->
  (s) ->
    rv = mat3.create()
    new Mat3(func(rv, @internal, s))

class Mat3
  constructor: (args) ->
    if args instanceof Float32Array
      @internal = mat3.clone(args)
    else if args instanceof Mat3
      @internal = mat3.clone(args.internal)
    else
      @internal = mat3.create()

  determinant: scalarUnaryOp(mat3.determinant)
  str: scalarUnaryOp(mat3.str)
  
  adjoint: matrixUnaryOp(mat3.adjoint)
  inverse: matrixUnaryOp(mat3.invert)
  invert: matrixUnaryOp(mat3.invert)
  transpose: matrixUnaryOp(mat3.transpose)

  mul: matrixBinaryOp(mat3.multiply)
  multiply: matrixBinaryOp(mat3.multiply)
  scale: matrixBinaryOp(mat3.scale)
  translate: matrixBinaryOp(mat3.translate)

  rotate: matrixBinaryOpByScalar(mat3.rotate)

Mat3.fromMat2d = factory(mat3.fromMat2d)
Mat3.fromMat4 = factory(mat3.fromMat4)
Mat3.fromQuat = factory(mat3.fromQuat)
Mat3.normalFromMat4 = factory(mat3.normalFromMat4)

window.Mat3 = window.M3 = Mat3
