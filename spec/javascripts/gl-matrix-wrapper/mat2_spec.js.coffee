#= require gl-matrix-wrapper

describe "Mat2", ->
  glm_identity = null
  glm_rot60 = null
  identity = null
  rot60 = null

  beforeEach ->
    glm_identity = mat2.create()
    glm_rot60 = mat2.create()
    mat2.rotate(glm_rot60, glm_rot60, Math.PI / 3.0)

    identity = new Mat2(glm_identity)
    rot60 = new Mat2(glm_rot60)

  describe "constructor", ->
    it "should create the identity matrix by default", ->
      expect((new Mat2()).internal).toEqual(glm_identity)

    it "should wrap an already-existing gl-matrix object", ->
      expect((new Mat2(glm_rot60)).internal).toEqual(glm_rot60)

    it "should duplicate an already-existing Mat2", ->
      expect(new Mat2(rot60)).toEqual(rot60)

    it "should create the identity matrix with any other parameters", ->
      expect(new Mat2("other", "parameters")).toEqual(identity)
