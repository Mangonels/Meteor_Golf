extends Node3D

@export var RotationSpeed = 2.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Update height
	if Input.is_action_pressed("move_up"):
		rotate(Vector3.RIGHT, RotationSpeed * delta)

	if Input.is_action_pressed("move_down"):
		rotate(Vector3.RIGHT, -RotationSpeed * delta)
