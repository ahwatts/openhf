WrapperUtils =
  factory: (type, internalType, func) ->
    (args...) ->
      fixedArgs = []
      for a in args
        fixedArgs.push(if a.hasOwnProperty('internal') then a.internal else a)
      rv = internalType.create()
      fixedArgs.unshift(rv)
      new type(func.apply(null, fixedArgs))


  scalarUnaryOp: (func) ->
    () ->
      func(@internal)

  scalarBinaryOp: (func) ->
    (other) ->
      func(@internal, other.internal)

  scalarBinaryOpByScalar: (func) ->
    (s) ->
      func(@internal, s)


  typedUnaryOp: (type, internalType, func) ->
    () ->
      rv = internalType.create()
      rv = func(rv, @internal)
      if rv then new type(rv) else null

  typedBinaryOp: (type, internalType, func) ->
    (other) ->
      rv = internalType.create()
      new type(func(rv, @internal, other.internal))

  typedBinaryOpByScalar: (type, internalType, func) ->
    (s) ->
      rv = internalType.create()
      new type(func(rv, @internal, s))


  typedParameterizedBinaryOp: (type, internalType, func) ->
    (other, t) ->
      rv = internalType.create()
      new type(func(rv, @internal, other.internal, t))


  partiallyApplyTypes: (type, internalType) ->
    rv = {}
    for k of WrapperUtils
      do (k) ->
        if WrapperUtils[k].length == 3
          rv[k] = (wrappedFunc) -> WrapperUtils[k](type, internalType, wrappedFunc)
        else
          rv[k] = WrapperUtils[k]
    rv

window.WrapperUtils = WrapperUtils
