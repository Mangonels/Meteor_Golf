extends RigidBody3D

@export var RotationSpeed = 2.0

@export var OrbitalFollowCamera: Node = null

# Called when the node enters the scene tree for the first time.
#func _ready():
#	apply_central_impulse(Vector3(-3, 3, -3))

func _physics_process(delta):

	if Input.is_action_pressed("move_up"):
		$DirectionalPivot.rotate(Vector3.RIGHT, RotationSpeed * delta)

	if Input.is_action_pressed("move_down"):
		$DirectionalPivot.rotate(Vector3.RIGHT, -RotationSpeed * delta)
		
	if Input.is_action_pressed("swing"):
		throw_golf_ball()

func _process(delta):
	$DirectionalPivot.rotation.y = OrbitalFollowCamera.rotation.y

# Function to throw the golf ball in the forward direction
func throw_golf_ball():
	var forwardVector = get_forward_vector()
	var throwForce = 3.0
	apply_central_impulse(forwardVector * throwForce)

# Function to get the forward vector of the DirectionPivot
func get_forward_vector():
	return -$DirectionalPivot.global_transform.basis.z
