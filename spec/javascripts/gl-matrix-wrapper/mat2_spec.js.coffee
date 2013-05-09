#= require gl-matrix
#= require gl-matrix-wrapper

describe "Mat2", ->
  glm_nonsingular = null
  glm_singular = null
  glm_identity = null
  glm_rot60 = null
  nonsingular = null
  singular = null
  identity = null
  rot60 = null

  beforeEach ->
    glm_nonsingular = mat2.clone([ 1, 2, 3, 4 ])
    glm_singular = mat2.clone([ 1, 2, 3, 6 ])
    glm_identity = mat2.create()
    glm_rot60 = mat2.create()
    mat2.rotate(glm_rot60, glm_rot60, Math.PI / 3.0)

    nonsingular = new Mat2(glm_nonsingular)
    singular = new Mat2(glm_singular)
    identity = new Mat2(glm_identity)
    rot60 = new Mat2(glm_rot60)

  describe "constructor", ->
    it "creates the identity matrix by default", ->
      expect((new Mat2()).internal).toEqual(glm_identity)

    it "wraps an already-existing gl-matrix object", ->
      expect((new Mat2(glm_rot60)).internal).toEqual(glm_rot60)

    it "duplicates an already-existing Mat2", ->
      expect(new Mat2(rot60)).toEqual(rot60)

    it "creates the identity matrix with any other parameters", ->
      expect(new Mat2("other", "parameters")).toEqual(identity)


  describe "determinant", ->
    it "returns 1 as the determinant of the identity matrix", ->
      expect(identity.determinant()).toEqual(1)

    it "returns the determinant of a non-singular matrix", ->
      expect(nonsingular.determinant()).toEqual(-2)

    it "returns 0 as the determinant of a singular matrix", ->
      expect(singular.determinant()).toEqual(0)

  describe "str", ->
    it "returns a string representation of a Mat2", ->
      expect(identity.str()).toEqual("mat2(1, 0, 0, 1)")

  describe "adjoint", ->
    it "returns the adjoint of a matrix", ->
      expect(nonsingular.adjoint().internal).toEqual(new Float32Array([ 4, -2, -3, 1]))

  describe "inverse", ->
    it "returns the inverse of a nonsingular matrix", ->
      expect(nonsingular.inverse().internal).toEqual(new Float32Array([ -2, 1, 1.5, -0.5 ]))

    it "returns null for a singular matrix", ->
      expect(singular.inverse()).toEqual(null)

  describe "transpose", ->
    it "returns the transpose of a matrix", ->
      expect(nonsingular.transpose().internal).toEqual(new Float32Array([ 1, 3, 2, 4 ]))

  describe "multiply", ->
    it "returns the product of two matrices", ->
      expect(nonsingular.mul(singular).internal).toEqual(new Float32Array([ 7, 14, 15, 30 ]))

  describe "scale", ->
    it "returns the matrix scaled by a vec2", ->
      expect(nonsingular.scale(new Vec2(2, 3)).internal).toEqual(new Float32Array([ 2, 6, 6, 12 ]))

  describe "rotate", ->
    it "returns the matrix rotated by an angle in radians", ->
      val = Math.sqrt(2) / 2.0
      expect(identity.rotate(Math.PI / 4).internal).toEqual(new Float32Array([ val, -val, val, val ]))
      expect(identity.rotate(-1*Math.PI / 4).internal).toEqual(new Float32Array([ val, val, -val, val ]))
