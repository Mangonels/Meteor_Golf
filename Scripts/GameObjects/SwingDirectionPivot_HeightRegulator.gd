extends Node3D

@export var RotationSpeed = 2.0

var HeightRotationClampRange = 60

func _process(delta):
	#Update height
	if Input.is_action_pressed("move_up"):
		rotate(Vector3.RIGHT, RotationSpeed * delta)

	if Input.is_action_pressed("move_down"):
		rotate(Vector3.RIGHT, -RotationSpeed * delta)

	#Clamp rotation into range
	var currentRotationX = rotation.x
	currentRotationX = clamp(currentRotationX, deg_to_rad(-HeightRotationClampRange), deg_to_rad(HeightRotationClampRange))
	rotation.x = currentRotationX
