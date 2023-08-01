extends Node3D

#The directional pivot also includes swinging functionality

@export var RotationSpeed = 2.0
@export var NotableMeteorVelThreshold = 1
@export var MaxMeteorImpulsePotency = 20.0
@export var SwingPowerMarkerSpeed = 2

@onready var Meteorite: Node = get_tree().get_root().get_node("Level/MeteoriteBall")
@onready var OrbitalFollowCamera: Node = get_tree().get_root().get_node("Level/OrbitalFollowCamera")
@onready var SwingAvailability: Node = get_tree().get_root().get_node("Level/HUD/SwingAvailability")
@onready var DrivePowerDisplay: Node = get_tree().get_root().get_node("Level/HUD/DrivePowerDisplay")

var CanSwing = false
var SwingingUp = false
var SwingValue = 0.0

func _process(delta):
	transform.origin = Meteorite.transform.origin 

	#Update orientation
	rotation.y = OrbitalFollowCamera.rotation.y
	
	#We can swing at the meteorite if it's Grounded and velocities are below NewStrokeBelowVelThreshold
	if Meteorite.Grounded and Meteorite.angular_velocity.length() < NotableMeteorVelThreshold and Meteorite.linear_velocity.length() < NotableMeteorVelThreshold:
		CanSwing = true
		SwingAvailability.show()
	else: 
		CanSwing = false
		SwingAvailability.hide()
	
	#Gameplay mechanic 1: Can apply horizontal force to meteorite?
	if SwingValue > 0.0 and Input.is_action_just_pressed("swing"):
		#Give impulse order according to swing potency
		Meteorite.do_impulse_self(SwingValue * MaxMeteorImpulsePotency)
		GameManager.add_stroke()
		SwingValue = 0.0
		SwingingUp = false
		DrivePowerDisplay.hide()
	#Can start drive power minigame?
	elif !SwingingUp and CanSwing and Input.is_action_just_pressed("swing"):
		SwingingUp = true
		DrivePowerDisplay.show()
	#Gameplay mechanic 2: Can apply downward force to meteorite?
	elif !Meteorite.Grounded and SwingValue == 0.0 and Meteorite.linear_velocity.length() > NotableMeteorVelThreshold and Input.is_action_just_pressed("swing"):
		Meteorite.do_downfall()

	#SwingingUp increases SwingValue
	if SwingingUp:
		SwingValue += (delta * SwingPowerMarkerSpeed)
		SwingValue = clamp(SwingValue, 0.0, 1.0)
		DrivePowerDisplay.set_power_measure(SwingValue)
		if SwingValue == 1.0:
			SwingingUp = false
	#SwingValue is decreased if not SwingingUp and SwingValue is above 0.0
	elif SwingValue > 0.0:
		SwingValue -= (delta * SwingPowerMarkerSpeed)
		SwingValue = clamp(SwingValue, 0.0, 1.0)
		DrivePowerDisplay.set_power_measure(SwingValue)
		if SwingValue == 0.0:
			DrivePowerDisplay.hide()
