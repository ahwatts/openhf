#= require gl-matrix

scalarUnaryOp = (func) ->
  () ->
    func(@internal)

matrixUnaryOp = (func) ->
  () ->
    rv = mat2.create()
    new Mat2(func(rv, @internal))

matrixBinaryOp = (func) ->
  (other) ->
    rv = mat2.create()
    new Mat2(func(rv, @internal, other.internal))

matrixBinaryOpByScalar = (func) ->
  (s) ->
    rv = mat2.create()
    new Mat2(func(rv, @internal, s))

class Mat2
  constructor: (args) ->
    if args instanceof Float32Array
      @internal = mat2.clone(args)
    else if args instanceof Mat2
      @internal = mat2.clone(args.internal)
    else
      @internal = mat2.create()

  determinant: scalarUnaryOp(mat2.determinant)
  str: scalarUnaryOp(mat2.str)

  adjoint: matrixUnaryOp(mat2.adjoint)
  inverse: matrixUnaryOp(mat2.invert)
  invert: matrixUnaryOp(mat2.invert)
  transpose: matrixUnaryOp(mat2.transpose)

  mul: matrixBinaryOp(mat2.multiply)
  multiply: matrixBinaryOp(mat2.multiply)

  rotate: matrixBinaryOpByScalar(mat2.rotate)
  scale: matrixBinaryOpByScalar(mat2.scale)
