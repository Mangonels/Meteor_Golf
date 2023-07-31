extends RigidBody3D

@export var RotationSpeed = 2.0
@export var RespawnHeightThreshold = 0

@onready var OrbitalFollowCamera: Node = get_tree().get_root().get_node("Level/OrbitalFollowCamera")
@onready var SwingDirectionPivotBase: Node = get_tree().get_root().get_node("Level/SwingDirectionPivot")
@onready var DirectionalPivotHeightRegulator: Node = get_tree().get_root().get_node("Level/SwingDirectionPivot/HeightRegulator")

var Grounded = true

func _ready():
	#Contact checking for grounded detections setup:
	set_contact_monitor(true)
	set_max_contacts_reported(1)

func _process(delta):
	#print("grounded: " + str(Grounded) + " canswing: " + str(CanSwing))
	#print("angular vel: " + str(angular_velocity.length()) + " linear vel: " + str(linear_velocity.length()))
	
	SwingDirectionPivotBase.rotation.y = OrbitalFollowCamera.rotation.y
	
	if Input.is_action_pressed("move_up"):
		DirectionalPivotHeightRegulator.rotate(Vector3.RIGHT, RotationSpeed * delta)

	if Input.is_action_pressed("move_down"):
		DirectionalPivotHeightRegulator.rotate(Vector3.RIGHT, -RotationSpeed * delta)
	
	#The meteorite is considered grounded as long as anything is touching it
	if get_contact_count() == 1:
		Grounded = true
	else: Grounded = false
	
	#Meteorite height offlimits respawn
	if position.y < RespawnHeightThreshold:
		GameManager.respawn_meteorite(self)

# Function to throw the golf ball in the forward direction
func impulse_self(impulseForce: float):
	var orientationRotation = SwingDirectionPivotBase.rotation.y
	var heightRotation = DirectionalPivotHeightRegulator.rotation.x
	
	var directionTransform = Transform3D(Basis(Vector3(0, 1, 0), orientationRotation) * Basis(Vector3(1, 0, 0), heightRotation))
	var directionVector = -directionTransform.basis.z
	
	apply_central_impulse(directionVector * impulseForce)

# Function to get the forward vector of the DirectionPivot
func get_forward_vector():
	return -SwingDirectionPivotBase.global_transform.basis.z
