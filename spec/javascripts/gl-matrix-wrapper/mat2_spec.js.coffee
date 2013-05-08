#= require gl-matrix-wrapper

describe "Mat2", ->
  it "should create the identity matrix by default", ->
    expect(new Mat2().internal).toBe([1, 0, 0, 1])
