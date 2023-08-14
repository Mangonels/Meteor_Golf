extends Node3D

# Simple Orbital Follow Camera (OFC) implementation script

@export var CameraTarget: Node = null

@export var OFCDisplacement: Vector3 = Vector3(0, 2, 0)
@export var OrbitalRotationSpeed = 0.2
@export var OrbitDistanceVariation = 1
@export var OFCDistance = 12.0
@export var MaxOFCDistance = 25.0
@export var MinOFCDistance = 3.5

@export var OrbitingEnabled = true
@export var DistanceZoomingEnabled = true

func _ready():
	$SpringArm3D.spring_length = OFCDistance

func _input(event):
	if OrbitingEnabled and event is InputEventMouseMotion:
		rotation.x -= deg_to_rad(event.relative.y) * OrbitalRotationSpeed
		rotation.x = clamp(rotation.x, deg_to_rad(-90), deg_to_rad(90))
		rotation.y -= deg_to_rad(event.relative.x) * OrbitalRotationSpeed
	
	if DistanceZoomingEnabled and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			OFCDistance = clamp(OFCDistance - OrbitDistanceVariation, MinOFCDistance, MaxOFCDistance)
			$SpringArm3D.spring_length = OFCDistance
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			OFCDistance = clamp(OFCDistance + OrbitDistanceVariation, MinOFCDistance, MaxOFCDistance)
			$SpringArm3D.spring_length = OFCDistance

func _process(delta):
	transform.origin = CameraTarget.transform.origin + OFCDisplacement
	
func disable_orbiting():
	OrbitingEnabled = false
	
func enable_orbiting():
	OrbitingEnabled = true
