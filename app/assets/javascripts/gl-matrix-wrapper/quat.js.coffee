#= require gl-matrix
#= require gl-matrix-wrapper/wrapper_utils

class Quat
  constructor: (args) ->
    if args instanceof Float32Array
      @internal = quat.clone(args)
    else if args instanceof Quat
      @internal = quat.clone(args.internal)
    else
      @internal = quat.create()

    [ @x, @y, @z, @w ] = @internal

F = WrapperUtils.partiallyApplyTypes(Quat, quat)

Quat::len = F.scalarUnaryOp(quat.length)
Quat::length = F.scalarUnaryOp(quat.length)
Quat::sqrLen = F.scalarUnaryOp(quat.squaredLength)
Quat::squaredLength = F.scalarUnaryOp(quat.squaredLength)
Quat::str = F.scalarUnaryOp(quat.str)

Quat::calculateW = F.typedUnaryOp(quat.calculateW)
Quat::conjugate = F.typedUnaryOp(quat.conjugate)
Quat::inverse = F.typedUnaryOp(quat.inverse)
Quat::invert = F.typedUnaryOp(quat.invert)
Quat::normalize = F.typedUnaryOp(quat.normalize)

Quat::dot = F.scalarBinaryOp(quat.dot)

Quat::add = F.typedBinaryOp(quat.add)
Quat::mul = F.typedBinaryOp(quat.multiply)
Quat::multiply = F.typedBinaryOp(quat.multiply)

Quat::rotateX = F.typedBinaryOpByScalar(quat.rotateX)
Quat::rotateY = F.typedBinaryOpByScalar(quat.rotateY)
Quat::rotateZ = F.typedBinaryOpByScalar(quat.rotateZ)
Quat::scale = F.typedBinaryOpByScalar(quat.scale)

Quat::lerp = F.typedParameterizedBinaryOp(quat.lerp)
Quat::slerp = F.typedParameterizedBinaryOp(quat.slerp)

Quat.fromAxisAngle = F.factory(quat.setAxisAngle)
Quat.fromMat3 = F.factory(quat.fromMat3)
Quat.fromValues = F.factory(quat.set)

window.Quat = window.Q = Quat
