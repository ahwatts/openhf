#= require gl-matrix

scalarUnaryOp = (func) ->
  () ->
    func(@internal)

matrixUnaryOp = (func) ->
  () ->
    rv = mat2d.create()
    new Mat2d(func(rv, @internal))

matrixBinaryOp = (func) ->
  (other) ->
    rv = mat2d.create()
    new Mat2d(func(rv, @internal, other.internal))

matrixBinaryOpByScalar = (func) ->
  (s) ->
    rv = mat2d.create()
    new Mat2d(func(rv, @internal, s))

class Mat2d
  constructor: (args) ->
    if args instanceof Float32Array
      @internal = mat2d.clone(args)
    else if args instanceof Mat2d
      @internal = mat2d.clone(args.internal)
    else
      @internal = mat2d.create()

  determinant: scalarUnaryOp(mat2d.determinant)
  str: scalarUnaryOp(mat2d.str)

  inverse: matrixUnaryOp(mat2d.invert)
  invert: matrixUnaryOp(mat2d.invert)

  mul: matrixBinaryOp(mat2d.multiply)
  multiply: matrixBinaryOp(mat2d.multiply)
  scale: matrixBinaryOp(mat2d.scale)
  translate: matrixBinaryOp(mat2d.translate)

  rotate: matrixBinaryOpByScalar(mat2d.rotate)

window.Mat2d = window.M2d = Mat2d
