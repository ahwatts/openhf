#= require gl-matrix
#= require gl-matrix-wrapper/wrapper_utils

class Mat3
  constructor: (args...) ->
    @internal = null

    if args.length == 1
      if args[0].hasOwnProperty('internal')
        @internal = mat3.clone(args[0].internal)
      else if args instanceof Float32Array
        @internal = mat3.clone(args[0])

    if @internal == null
      @internal = mat3.create()

F = WrapperUtils.partiallyApplyTypes(Mat3, mat3)

Mat3::determinant = F.scalarUnaryOp(mat3.determinant)
Mat3::str = F.scalarUnaryOp(mat3.str)
  
Mat3::adjoint = F.typedUnaryOp(mat3.adjoint)
Mat3::inverse = F.typedUnaryOp(mat3.invert)
Mat3::invert = F.typedUnaryOp(mat3.invert)
Mat3::transpose = F.typedUnaryOp(mat3.transpose)

Mat3::mul = F.typedBinaryOp(mat3.multiply)
Mat3::multiply = F.typedBinaryOp(mat3.multiply)
Mat3::scale = F.typedBinaryOp(mat3.scale)
Mat3::translate = F.typedBinaryOp(mat3.translate)

Mat3::rotate = F.typedBinaryOpByScalar(mat3.rotate)

Mat3.fromMat2d = F.factory(mat3.fromMat2d)
Mat3.fromMat4 = F.factory(mat3.fromMat4)
Mat3.fromQuat = F.factory(mat3.fromQuat)
Mat3.normalFromMat4 = F.factory(mat3.normalFromMat4)

window.Matrix3 = window.Mat3 = window.M3 = Mat3
