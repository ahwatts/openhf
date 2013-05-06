WrapperUtils =
  factory: (type, internalType, func) ->
    (args...) ->
      fixedArgs = if a.hasOwnProperty('internal') then a.internal else a for a in args
      rv = internalType.create()
      fixedArgs.unshift(rv)
      new type(func.call(fixedArgs))


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
      new type(func(rv, @internal))

  typedBinaryOp: (type, internalType, func) ->
    (other) ->
      rv = internalType.create()
      new type(func(rv, @internal, other.internal))

  typedBinaryOpByScalar: (type, internalType, func) ->
    (s) ->
      rv = internalType.create()
      new type(func(rv, @internal, s))


  partiallyApplyTypes: (wrapperFuncs, type, internalType) ->
    rv = {}
    for k of wrapperFuncs
      do (k) ->
        if wrapperFuncs[k].length == 3
          rv[k] = (wrappedFunc) -> wrapperFuncs[k](type, internalType, wrappedFunc)
        else
          rv[k] = wrapperFuncs[k]
    rv

window.WrapperUtils = WrapperUtils
