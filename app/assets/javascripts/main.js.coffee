# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

ROOT_EIGHT = 2.82843

mainLoop = (renderer, camera, scene) ->
  time = 0.0
  update = () ->
    time += 0.03
    if time > ROOT_EIGHT
      time = -ROOT_EIGHT
    sphere = scene.getChildByName('sphere', false)
    sphere.position.y = -(time*time) + 8

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
  sphere.up = new THREE.Vector3(0, 1, 0)

  lights = [
    new THREE.PointLight(0xFFFFFF),
    # new THREE.PointLight(0xFFFFFF)
  ]
  lights[0].position = new THREE.Vector3(0, 20, 0)
  # lights[1].position = new THREE.Vector3(0, 20, 20)

  scene = new THREE.Scene()
  scene.add(camera)
  scene.add(sphere)
  scene.add(ground)
  for l in lights
    scene.add(l)

  canvas = $(renderer.domElement)
  canvas.css('position', 'absolute')
  canvas.css('top', '0px')

  $("#openhf_container").append(renderer.domElement)

  mainLoop(renderer, camera, scene)
