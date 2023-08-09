extends RigidBody3D

@export var DownfallImpulse = 60.0
@export var RespawnHeightThreshold = 0
@export var HighLinearVelocityThreshold = 10

@onready var SwingDirectionPivotBase: Node = get_tree().get_root().get_node("Level/SwingDirectionPivot")
@onready var DirectionalPivotHeightRegulator: Node = get_tree().get_root().get_node("Level/SwingDirectionPivot/HeightRegulator")

var TimeSinceLastGrounded = 0.0
var PreviousPhysicsUpdateVelocity = Vector3.ZERO
var PreviousPhysicsContactCount = 0

func is_grounded():
	return TimeSinceLastGrounded == 0.0

func _ready():
	#Contact checking for grounded detections setup:
	set_contact_monitor(true)
	set_max_contacts_reported(1)

#Normal loop (fewer frames than _integrate_forces)
func _process(delta):
	#print("grounded: " + str(Grounded) + " canswing: " + str(CanSwing))
	#print("angular vel: " + str(angular_velocity.length()) + " linear vel: " + str(linear_velocity.length()))
	
	#The meteorite is considered grounded as long as anything is touching it
	if get_contact_count() == 1:
		TimeSinceLastGrounded = 0.0
	else:
		TimeSinceLastGrounded += delta

	#Meteorite height offlimits respawn
	if position.y < RespawnHeightThreshold:
		GameManager.respawn_meteorite(self)

#A higher frame count loop for physic calculations
func _integrate_forces(state):
	var currentContactCount = state.get_contact_count()
	var currentLinearVelocity = state.get_linear_velocity()

	if currentContactCount > 0 and PreviousPhysicsContactCount == 0 and PreviousPhysicsUpdateVelocity.length() > HighLinearVelocityThreshold:
		var collisionPoint = state.get_contact_local_position(0)
		var collisionNormal = state.get_contact_local_normal(0)	
		spawn_impact_effect(collisionPoint, collisionNormal)
		
	PreviousPhysicsContactCount = currentContactCount
	PreviousPhysicsUpdateVelocity = currentLinearVelocity		

#Meteorite high velocity impact VFX
func spawn_impact_effect(collisionPoint: Vector3, collisionNormal: Vector3):
	var impactEffectInstance = load("res://GameObjects/ImpactExpansionEffect.tscn").instantiate()

	#Set position
	impactEffectInstance.transform.origin = collisionPoint
	
	#Set orientation
	#Create basis with collisionNormal as local up vector
	var basisY = collisionNormal.normalized()
	#Since we only know the local up vector is collisionNormal, we 
	#obtain the other perpendicular axes for the Basis by doing cross products:
	var basisZ = basisY.cross(Vector3.RIGHT).normalized()
	var basisX = basisY.cross(basisZ).normalized()

	var rotationBasis = Basis(basisX, basisY, basisZ)

	#Set the rotationBasis as rotation for the impact effect instance
	impactEffectInstance.transform.basis = rotationBasis
	
	get_parent().add_child(impactEffectInstance)

#Function to throw the golf ball in the forward direction
func do_impulse_self(impulseForce: float):
	var orientationRotation = SwingDirectionPivotBase.rotation.y
	print(str(orientationRotation))
	var heightRotation = DirectionalPivotHeightRegulator.rotation.x
	print(str(heightRotation))
	
	var directionTransform = Transform3D(Basis(Vector3(0, 1, 0), orientationRotation) * Basis(Vector3(1, 0, 0), heightRotation))
	var directionVector = -directionTransform.basis.z
	
	apply_central_impulse(directionVector * impulseForce)

func do_downfall():
	apply_central_impulse(Vector3.DOWN * DownfallImpulse)
