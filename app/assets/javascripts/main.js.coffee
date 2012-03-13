# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

renderer = null
scene = null
camera = null

drawScene = () ->
  requestAnimationFrame(drawScene)
  renderer.render(scene, camera)

$(document).ready ->
  renderer = new THREE.WebGLRenderer()
  camera = new THREE.PerspectiveCamera(45.0, 4.0 / 3.0, 0.1, 10000.0)
  scene = new THREE.Scene()

  sphere = new THREE.Mesh(
    new THREE.SphereGeometry(50, 16, 16),
    new THREE.MeshLambertMaterial({ color: 0xCC0000 }))

  pointLight = new THREE.PointLight(0xFFFFFF)
  pointLight.position.x = 10;
  pointLight.position.y = 50;
  pointLight.position.z = 130;

  scene.add(camera)
  scene.add(sphere)
  scene.add(pointLight)
  camera.position.z = 300
  renderer.setSize(800, 600)
  $("#openhf_container").append(renderer.domElement)
  drawScene()
