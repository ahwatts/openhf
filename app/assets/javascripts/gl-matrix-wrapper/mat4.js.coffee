#= require gl-matrix
#= require gl-matrix-wrapper/wrapper_utils

class Mat4
  constructor: (args) ->
    if args instanceof Float32Array
      @internal = mat4.clone(args)
    else if args instanceof Mat4
      @internal = mat4.clone(args.internal)
    else
      @internal = mat4.create()

F = WrapperUtils.partiallyApplyTypes(Mat4, mat4)

Mat4::determinant = F.scalarUnaryOp(mat4.determinant)
Mat4::str = F.scalarUnaryOp(mat4.str)
  
Mat4::adjoint = F.typedUnaryOp(mat4.adjoint)
Mat4::inverse = F.typedUnaryOp(mat4.invert)
Mat4::invert = F.typedUnaryOp(mat4.invert)
Mat4::transpose = F.typedUnaryOp(mat4.transpose)

Mat4::mul = F.typedBinaryOp(mat4.multiply)
Mat4::multiply = F.typedBinaryOp(mat4.multiply)
Mat4::scale = F.typedBinaryOp(mat4.scale)
Mat4::translate = F.typedBinaryOp(mat4.translate)

Mat4::rotate = F.typedBinaryOpByScalar(mat4.rotate)

Mat4.fromQuat = F.factory(mat4.fromQuat)
Mat4.fromRotationTranslation = F.factory(mat4.fromRotationTranslation)
Mat4.frustum = F.factory(mat4.frustum)
Mat4.lookAt = F.factory(mat4.lookAt)
Mat4.ortho = F.factory(mat4.ortho)
Mat4.perspective = F.factory(mat4.perspective)

window.Matrix4 = window.Mat4 = window.M4 = Mat4
