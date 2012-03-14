# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

ROOT_EIGHT = Math.sqrt(8)

mainLoop = (renderer, camera, scene) ->
  time = 0.0
  sphere = scene.getChildByName('sphere', false)

  update = () ->
    time += 0.06
    if time > ROOT_EIGHT
      time = -ROOT_EIGHT
    sphere.position.y = -(time*time) + 9

    requestAnimationFrame(update)
    renderer.render(scene, camera)

  update()


initRenderer = () ->
  renderer = new THREE.WebGLRenderer({
    antialias: true,
    preserveDrawingBuffer: true,
    clearColor: 0,
    clearAlpha: 1
  })
  renderer.setSize(window.innerWidth, window.innerHeight)
  renderer


$(document).ready ->
  renderer = initRenderer()

  camera = new THREE.PerspectiveCamera(45.0, renderer.domElement.width / renderer.domElement.height, 0.1, 10000.0)
  camera.position = new THREE.Vector3(0, 20, 20)
  camera.up = new THREE.Vector3(0, 1, 0)
  camera.lookAt(new THREE.Vector3(0, 3, 0))

  ground = new THREE.Mesh(
    new THREE.PlaneGeometry(10, 10, 1, 1),
    new THREE.MeshLambertMaterial({ color: 0x00CC00 }))
  ground.name = 'ground'
  ground.position = new THREE.Vector3(0, 0, 0)
  ground.rotation = new THREE.Vector3(-Math.PI / 2, 0, 0)

  sphere = new THREE.Mesh(
    new THREE.SphereGeometry(1, 16, 16),
    new THREE.MeshLambertMaterial({ color: 0xCC0000 }))
  sphere.name = 'sphere'
  sphere.position = new THREE.Vector3(0, 1, 0)

  light = new THREE.PointLight(0xFFFFFF)
  light.position = new THREE.Vector3(0, 20, 0)

  scene = new THREE.Scene()
  scene.add(camera)
  scene.add(sphere)
  scene.add(ground)
  scene.add(light)

  canvas = $(renderer.domElement)
  canvas.css('position', 'absolute')
  canvas.css('top', '0px')

  $(window).bind 'resize', (event) ->
    renderer.setSize(window.innerWidth, window.innerHeight)
    camera.aspect = window.innerWidth / window.innerHeight
    camera.updateProjectionMatrix()

  $("#openhf_container").append(renderer.domElement)

  mainLoop(renderer, camera, scene)
