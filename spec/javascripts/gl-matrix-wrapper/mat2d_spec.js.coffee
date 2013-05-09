#= require gl-matrix
#= require gl-matrix-wrapper

describe "Mat2d", ->
  glm_identity = null
  glm_rot60 = null
  glm_trans2x1y = null
  glm_singular = null
  
  identity = null
  rot60 = null
  trans2x1y = null
  singular = null

  beforeEach ->
    glm_identity = mat2d.create()
    glm_rot60 = mat2d.create()
    glm_trans2x1y = mat2d.create()
    glm_singular = mat2d.clone([ 1, 2, 2, 4, 3, 6 ])
    mat2d.rotate(glm_rot60, glm_rot60, Math.PI / 3.0)
    mat2d.translate(glm_trans2x1y, glm_trans2x1y, vec2.fromValues(2, 1))
    
    identity = new Mat2d(glm_identity)
    rot60 = new Mat2d(glm_rot60)
    trans2x1y = new Mat2d(glm_trans2x1y)
    singular = new Mat2d(glm_singular)

  describe "constructor", ->
    it "creates the identity matrix by default", ->
      expect((new Mat2d()).internal).toEqual(glm_identity)

    it "wraps an already-existing mat2d object", ->
      expect((new Mat2d(glm_rot60)).internal).toEqual(glm_rot60)

    it "clones an already-existing Mat2d object", ->
      expect(new Mat2d(glm_rot60)).toEqual(rot60)

  describe "determinant", ->
    it "returns 1 for the determinant of the identity matrix", ->
      expect(identity.determinant()).toEqual(1)

    it "returns 1 for the determinant of a rotation matrix", ->
      expect(rot60.determinant()).toBeCloseTo(1, 6)

    it "returns 0 for the determinant of a singular matrix", ->
      expect(singular.determinant()).toEqual(0)

  describe "str", ->
    it "returns a string representation of the Mat2d", ->
      expect(trans2x1y.str()).toEqual("mat2d(1, 0, 0, 1, 2, 1)")

  describe "inverse", ->
    it "returns the inverse of a nonsingular matrix", ->
      expect(trans2x1y.inverse().internal).toEqual(new Float32Array([ 1, 0, 0, 1, -2, -1 ]))

    it "returns null as the inverse of a singular matrix", ->
      expect(singular.inverse()).toBe(null)
