#= require gl-matrix

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
    else if args instanceof Mat2d
      @internal = mat3.create()
      mat3.fromMat2d(@internal, args.internal)
    else if args instanceof Mat3
      @internal = mat3.clone(args.internal)
    else if args instanceof Mat4
      @internal = mat3.create()
      mat3.fromMat4(@internal, args.internal)
    else if args instanceof Quat
      @internal = mat3.create()
      mat3.fromQuat(@internal, args.internal)
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

Mat3.normalFromMat4 = (m) ->
  rv = mat3.create()
  if m instanceof Float32Array
    new Mat3(mat3.normalFromMat4(rv, m))
  else
    new Mat3(mat3.normalFromMat4(rv, m.internal))

window.Mat3 = window.M3 = Mat3
