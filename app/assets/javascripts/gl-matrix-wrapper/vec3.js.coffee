#= require gl-matrix
#= require gl-matrix-wrapper/wrapper_utils

class Vector3
  constructor: (args) ->
    if arguments.length == 3
      @internal = vec3.clone(arguments)
    else if args instanceof Float32Array
      @internal = vec3.clone(args)
    else if args instanceof Vector3
      @internal = vec3.clone(args.internal)
    else
      @internal = vec3.create()

    [ @x, @y, @z ] = @internal

  add: vectorBinaryOp(vec3.add)
  cross: vectorBinaryOp(vec3.cross)
  divide: vectorBinaryOp(vec3.divide)
  div: vectorBinaryOp(vec3.divide)
  max: vectorBinaryOp(vec3.max)
  min: vectorBinaryOp(vec3.min)
  mul: vectorBinaryOp(vec3.multiply)
  multiply: vectorBinaryOp(vec3.multiply)
  sub: vectorBinaryOp(vec3.subtract)
  subtract: vectorBinaryOp(vec3.subtract)

  dist: scalarBinaryOp(vec3.distance)
  distance: scalarBinaryOp(vec3.distance)
  dot: scalarBinaryOp(vec3.dot)
  sqrDist: scalarBinaryOp(vec3.squaredDistance)
  squaredDistance: scalarBinaryOp(vec3.squaredDistance)

  negate: vectorUnaryOp(vec3.negate)
  normalize: vectorUnaryOp(vec3.normalize)

  len: scalarUnaryOp(vec3.length)
  length: scalarUnaryOp(vec3.length)
  sqrLen: scalarUnaryOp(vec3.squaredLength)
  squaredLength: scalarUnaryOp(vec3.squaredLength)
  str: scalarUnaryOp(vec3.str)

  lerp: (other, t) ->
    rv = vec3.create()
    new Vector3(vec3.lerp(rv, @internal, other.internal, t))

  scale: (a) ->
    rv = vec3.create()
    new Vector3(vec3.scale(rv, @internal, a))

  scaleAndAdd: (other, a) ->
    rv = vec3.create()
    new Vector3(vec3.scaleAndAdd(rv, @internal, other.internal, a))

  transformM3: () -> undefined.notImplemented
  transformM4: () -> undefined.notImplemented
  transformQ: () -> undefined.notImplemented

Vector3.random = (scale) ->
  rv = vec3.create()
  vec3.random(rv, scale)

window.Vector3 = window.V3 = Vector3
