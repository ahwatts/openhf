#= require gl-matrix
#= require gl-matrix-wrapper

describe "Mat2d", ->
  glm_identity = null
  glm_rot60 = null
  glm_trans2x1y = null
  
  identity = null
  rot60 = null
  trans2x1y = null

  beforeEach ->
    glm_identity = mat2d.create()
    glm_rot60 = mat2d.create()
    glm_trans2x1y = mat2d.create()
    mat2d.rotate(glm_rot60, glm_rot60, Math.PI / 3.0)
    mat2d.translate(glm_trans2x1y, glm_trans2x1y, vec2.fromValues(2, 1))
    
    identity = new Mat2d(glm_identity)
    rot60 = new Mat2d(glm_rot60)
    trans2x1y = new Mat2d(glm_trans2x1y)

  describe "constructor", ->
    it "creates the identity matrix by default", ->
      expect((new Mat2d()).internal).toEqual(glm_identity)

    it "wraps an already-existing mat2d object", ->
      expect((new Mat2d(glm_rot60)).internal).toEqual(glm_rot60)
