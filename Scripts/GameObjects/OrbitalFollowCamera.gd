extends Node3D

# Simple Orbital Follow Camera (OFC) implementation script

@export var SpringArm : SpringArm3D
@export var Camera : Camera3D

@export var CameraTarget: Node = null

@export var OFCDisplacement: Vector3 = Vector3(0, 2, 0)
@export var OrbitalRotationSpeed = 0.2
@export var OrbitDistanceVariation = 1
@export var OFCDistance = 12.0
@export var MaxOFCDistance = 25.0
@export var MinOFCDistance = 3.5

@export var OrbitingEnabled = true
@export var DistanceZoomingEnabled = true

@export var ShakeMaxRandomStrength: float = 1
@export var ShakeFade: float = 5

var RNG = RandomNumberGenerator.new()
var ShakeStrength: float = 0.0

func _ready():
	SpringArm.spring_length = OFCDistance

func _input(event):
	if OrbitingEnabled and event is InputEventMouseMotion:
		rotation.x -= deg_to_rad(event.relative.y) * OrbitalRotationSpeed
		rotation.x = clamp(rotation.x, deg_to_rad(-90), deg_to_rad(90))
		rotation.y -= deg_to_rad(event.relative.x) * OrbitalRotationSpeed
	
	if DistanceZoomingEnabled and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			OFCDistance = clamp(OFCDistance - OrbitDistanceVariation, MinOFCDistance, MaxOFCDistance)
			SpringArm.spring_length = OFCDistance
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			OFCDistance = clamp(OFCDistance + OrbitDistanceVariation, MinOFCDistance, MaxOFCDistance)
			SpringArm.spring_length = OFCDistance

func _process(delta):
	transform.origin = CameraTarget.transform.origin + OFCDisplacement
	
	if ShakeStrength > 0:
		ShakeStrength = lerpf(ShakeStrength, 0, ShakeFade * delta)
		Camera.h_offset = random_offset()
		Camera.v_offset = random_offset()

func disable_orbiting():
	OrbitingEnabled = false
	
func enable_orbiting():
	OrbitingEnabled = true

func random_offset():
	return RNG.randf_range(-ShakeStrength, ShakeStrength)

func camera_shake(shakeMagnitudeFraction: float):
	ShakeStrength = ShakeMaxRandomStrength * shakeMagnitudeFraction
