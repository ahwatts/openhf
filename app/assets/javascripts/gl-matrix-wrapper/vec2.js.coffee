#= require gl-matrix
#= require gl-matrix-wrapper/wrapper_utils
#= require gl-matrix-wrapper/vec3

class Vec2
  constructor: (args...) ->
    switch args.length
      when 0 then @internal = vec2.create()
      when 1
        if args[0].hasOwnProperty('internal')
          @internal = vec2.clone(args[0].internal)
        else if args[0] instanceof Float32Array
          @internal = vec2.clone(args[0])
        else
          @internal = vec2.create()
      when 2 then @internal = vec2.fromValues.apply(null, args)
      else @internal = vec2.create()

    [ @x, @y ] = @internal

F = WrapperUtils.partiallyApplyTypes(Vec2, vec2)

Vec2::len = F.scalarUnaryOp(vec2.length)
Vec2::length = F.scalarUnaryOp(vec2.length)
Vec2::sqrLen = F.scalarUnaryOp(vec2.squaredLength)
Vec2::squaredLength = F.scalarUnaryOp(vec2.squaredLength)
Vec2::str = F.scalarUnaryOp(vec2.str)

Vec2::negate = F.typedUnaryOp(vec2.negate)
Vec2::negative = F.typedUnaryOp(vec2.negate)
Vec2::normalize = F.typedUnaryOp(vec2.normalize)
Vec2::normalized = F.typedUnaryOp(vec2.normalize)

Vec2::dist = F.scalarBinaryOp(vec2.distance)
Vec2::distance = F.scalarBinaryOp(vec2.distance)
Vec2::dot = F.scalarBinaryOp(vec2.dot)
Vec2::sqrDist = F.scalarBinaryOp(vec2.squaredDistance)
Vec2::squaredDistance = F.scalarBinaryOp(vec2.squaredDistance)

Vec2::add = F.typedBinaryOp(vec2.add)
Vec2::div = F.typedBinaryOp(vec2.divide)
Vec2::divide = F.typedBinaryOp(vec2.divide)
Vec2::max = F.typedBinaryOp(vec2.max)
Vec2::min = F.typedBinaryOp(vec2.min)
Vec2::mul = F.typedBinaryOp(vec2.multiply)
Vec2::multiply = F.typedBinaryOp(vec2.multiply)
Vec2::sub = F.typedBinaryOp(vec2.subtract)
Vec2::subtract = F.typedBinaryOp(vec2.subtract)
Vec2::transformMat2 = F.typedBinaryOp(vec2.transformMat2)
Vec2::transformMat2d = F.typedBinaryOp(vec2.transformMat2d)
Vec2::transformMat3 = F.typedBinaryOp(vec2.transformMat3)
Vec2::transformMat4 = F.typedBinaryOp(vec2.transformMat4)

Vec2::scale = F.typedBinaryOpByScalar(vec2.scale)

Vec2::lerp = F.typedParameterizedBinaryOp(vec2.lerp)
Vec2::scaleAndAdd = F.typedParameterizedBinaryOp(vec2.scaleAndAdd)

Vec2.fromValues = F.factory(vec2.set)
Vec2.random = F.factory(vec2.random)

Vec2::cross = (other) ->
  rv = vec2.create()
  new Vec3(vec2.cross(rv, @internal, other.internal))

window.Vector2 = window.Vec2 = window.V2 = Vec2
