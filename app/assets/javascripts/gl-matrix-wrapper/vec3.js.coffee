#= require gl-matrix
#= require gl-matrix-wrapper/wrapper_utils

class Vec3
  constructor: (args...) ->
    @internal = null

    if args.length == 1
      if args[0].hasOwnProperty('internal')
        @internal = vec3.clone(args[0].internal)
      else if args[0] instanceof Float32Array
        @internal = vec3.clone(args[0])
    else if args.length == 3
      @internal = vec3.fromValues.apply(null, args)

    if @internal == null
      @internal = vec3.create()

    [ @x, @y, @z ] = @internal

F = WrapperUtils.partiallyApplyTypes(Vec3, vec3)

Vec3::len = F.scalarUnaryOp(vec3.length)
Vec3::length = F.scalarUnaryOp(vec3.length)
Vec3::sqrLen = F.scalarUnaryOp(vec3.squaredLength)
Vec3::squaredLength = F.scalarUnaryOp(vec3.squaredLength)
Vec3::str = F.scalarUnaryOp(vec3.str)

Vec3::negate = F.typedUnaryOp(vec3.negate)
Vec3::negative = F.typedUnaryOp(vec3.negate)
Vec3::normalize = F.typedUnaryOp(vec3.normalize)
Vec3::normalized = F.typedUnaryOp(vec3.normalize)

Vec3::dist = F.scalarBinaryOp(vec3.distance)
Vec3::distance = F.scalarBinaryOp(vec3.distance)
Vec3::dot = F.scalarBinaryOp(vec3.dot)
Vec3::sqrDist = F.scalarBinaryOp(vec3.squaredDistance)
Vec3::squaredDistance = F.scalarBinaryOp(vec3.squaredDistance)

Vec3::add = F.typedBinaryOp(vec3.add)
Vec3::cross = F.typedBinaryOp(vec3.cross)
Vec3::div = F.typedBinaryOp(vec3.divide)
Vec3::divide = F.typedBinaryOp(vec3.divide)
Vec3::max = F.typedBinaryOp(vec3.max)
Vec3::min = F.typedBinaryOp(vec3.min)
Vec3::mul = F.typedBinaryOp(vec3.multiply)
Vec3::multiply = F.typedBinaryOp(vec3.multiply)
Vec3::sub = F.typedBinaryOp(vec3.subtract)
Vec3::subtract = F.typedBinaryOp(vec3.subtract)
Vec3::transformMat3 = F.typedBinaryOp(vec3.transformMat3)
Vec3::transformMat4 = F.typedBinaryOp(vec3.transformMat4)
Vec3::transformQuat = F.typedBinaryOp(vec3.transformQuat)

Vec3::scale = F.typedBinaryOpByScalar(vec3.scale)

Vec3::lerp = F.typedParameterizedBinaryOp(vec3.lerp)
Vec3::scaleAndAdd = F.typedParameterizedBinaryOp(vec3.scale)

Vec3.random = F.factory(vec3.random)

window.Vector3 = window.Vec3 = window.V3 = Vec3
