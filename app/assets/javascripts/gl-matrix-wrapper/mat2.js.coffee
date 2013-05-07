#= require gl-matrix
#= require gl-matrix-wrapper/wrapper_utils

# Forward declaration of the class we're defining.
class Mat2
  constructor: (args) ->
    if args instanceof Float32Array
      @internal = mat2.clone(args)
    else if args instanceof Mat2
      @internal = mat2.clone(args.internal)
    else
      @internal = mat2.create()

F = WrapperUtils.partiallyApplyTypes(Mat2, mat2d)

Mat2::determinant = F.scalarUnaryOp(mat2.determinant)
Mat2::str = F.scalarUnaryOp(mat2.str)

Mat2::adjoint = F.typedUnaryOp(mat2.adjoint)
Mat2::inverse = F.typedUnaryOp(mat2.invert)
Mat2::invert = F.typedUnaryOp(mat2.invert)
Mat2::transpose = F.typedUnaryOp(mat2.transpose)

Mat2::mul = F.typedBinaryOp(mat2.multiply)
Mat2::multiply = F.typedBinaryOp(mat2.multiply)
Mat2::scale = F.typedBinaryOpByScalar(mat2.scale)

Mat2::rotate = F.typedBinaryOpByScalar(mat2.rotate)

window.Matrix2 = window.Mat2 = window.M2 = Mat2
