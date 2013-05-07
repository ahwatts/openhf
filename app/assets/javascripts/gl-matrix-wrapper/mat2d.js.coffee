#= require gl-matrix
#= require gl-matrix-wrapper/wrapper_utils

# Forward declaration of the class we're defining.
class Mat2d
  constructor: (args) ->
    if args instanceof Float32Array
      @internal = mat2d.clone(args)
    else if args instanceof Mat2d
      @internal = mat2d.clone(args.internal)
    else
      @internal = mat2d.create()

F = WrapperUtils.partiallyApplyTypes(Mat2d, mat2d)

Mat2d::determinant = F.scalarUnaryOp(mat2d.determinant)
Mat2d::str = F.scalarUnaryOp(mat2d.str)

Mat2d::inverse = F.typedUnaryOp(mat2d.invert)
Mat2d::invert = F.typedUnaryOp(mat2d.invert)

Mat2d::mul = F.typedBinaryOp(mat2d.multiply)
Mat2d::multiply = F.typedBinaryOp(mat2d.multiply)
Mat2d::scale = F.typedBinaryOp(mat2d.scale)
Mat2d::translate = F.typedBinaryOp(mat2d.translate)

Mat2d::rotate = F.typedBinaryOpByScalar(mat2d.rotate)

window.Matrix2d = window.Mat2d = window.M2d = Mat2d
