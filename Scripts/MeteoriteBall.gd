extends RigidBody3D

@export var RotationSpeed = 2.0
@export var NewStrokeBelowVelThreshold = 0.1

@onready var OrbitalFollowCamera: Node = get_tree().get_root().get_node("Level/OrbitalFollowCamera")
@onready var DirectionalPivotBase: Node = get_tree().get_root().get_node("Level/DirectionalPivotBase")
@onready var DirectionalPivotHeightRegulator: Node = get_tree().get_root().get_node("Level/DirectionalPivotBase/HeightRegulator")

var Grounded = true
var CanSwing = false

func _ready():
	#Contact checking for grounded detections setup:
	set_contact_monitor(true)
	set_max_contacts_reported(1)

func _process(delta):
	#print("grounded: " + str(Grounded) + " canswing: " + str(CanSwing))
	#print("angular vel: " + str(angular_velocity.length()) + " linear vel: " + str(linear_velocity.length()))
	
	DirectionalPivotBase.rotation.y = OrbitalFollowCamera.rotation.y
	
	if Input.is_action_pressed("move_up"):
		DirectionalPivotHeightRegulator.rotate(Vector3.RIGHT, RotationSpeed * delta)

	if Input.is_action_pressed("move_down"):
		DirectionalPivotHeightRegulator.rotate(Vector3.RIGHT, -RotationSpeed * delta)
	
	#The meteorite is considered grounded as long as anything is touching it
	if get_contact_count() == 1:
		Grounded = true
	else: Grounded = false
	
	#We can swing at the meteorite if it's Grounded and velocities are below NewStrokeBelowVelThreshold
	if Grounded and angular_velocity.length() < NewStrokeBelowVelThreshold and linear_velocity.length() < NewStrokeBelowVelThreshold:
		CanSwing = true
	else: CanSwing = false
	
	if CanSwing and Input.is_action_just_pressed("swing"):
		throw_golf_ball()
		GameManager.add_stroke()

# Function to throw the golf ball in the forward direction
func throw_golf_ball():
	var orientationRotation = DirectionalPivotBase.rotation.y
	var heightRotation = DirectionalPivotHeightRegulator.rotation.x
	
	var directionTransform = Transform3D(Basis(Vector3(0, 1, 0), orientationRotation) * Basis(Vector3(1, 0, 0), heightRotation))
	var directionVector = -directionTransform.basis.z
	
	var impulseForce = 20.0
	apply_central_impulse(directionVector * impulseForce)

# Function to get the forward vector of the DirectionPivot
func get_forward_vector():
	return -DirectionalPivotBase.global_transform.basis.z
