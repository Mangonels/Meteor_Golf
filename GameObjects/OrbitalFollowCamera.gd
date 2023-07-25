extends Node3D

#Simple Orbital Follow Camera (OFC) implementation script

@export var CameraTarget: Node = null

@export var OFCDisplacement: Vector3 = Vector3(0, 2, 0)
@export var OrbitalRotationSpeed = 0.2
@export var OrbitDistanceVariation = 1
@export var MaxOrbitDistance = 25.0
@export var MinOrbitDistance = 3.5

var CameraDistance = 12.0

func _ready():
	$SpringArm3D.spring_length = CameraDistance

func _input(event):
	if event is InputEventMouseMotion:
		rotation.x -= deg_to_rad(event.relative.y) * OrbitalRotationSpeed
		rotation.x = clamp(rotation.x, deg_to_rad(-90), deg_to_rad(90))
		rotation.y -= deg_to_rad(event.relative.x) * OrbitalRotationSpeed
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			CameraDistance = clamp(CameraDistance - OrbitDistanceVariation, MinOrbitDistance, MaxOrbitDistance)
			$SpringArm3D.spring_length = CameraDistance
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			CameraDistance = clamp(CameraDistance + OrbitDistanceVariation, MinOrbitDistance, MaxOrbitDistance)
			$SpringArm3D.spring_length = CameraDistance

func _process(delta):
	transform.origin = CameraTarget.transform.origin + OFCDisplacement
