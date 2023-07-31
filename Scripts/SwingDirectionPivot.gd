extends Node3D

#The directional pivot also includes swinging functionality

@export var NewStrokeBelowVelThreshold = 0.5
@export var MaxMeteorImpulsePotency = 20.0

@onready var Meteorite: Node = get_tree().get_root().get_node("Level/MeteoriteBall")
@onready var SwingAvailability: Node = get_tree().get_root().get_node("Level/HUD/SwingAvailability")
@onready var DrivePowerDisplay: Node = get_tree().get_root().get_node("Level/HUD/DrivePowerDisplay")

var CanSwing = false
var SwingingUp = false
var SwingValue = 0.0

func _process(delta):
	transform.origin = Meteorite.transform.origin 

	#We can swing at the meteorite if it's Grounded and velocities are below NewStrokeBelowVelThreshold
	if Meteorite.Grounded and Meteorite.angular_velocity.length() < NewStrokeBelowVelThreshold and Meteorite.linear_velocity.length() < NewStrokeBelowVelThreshold:
		CanSwing = true
		SwingAvailability.show()
	else: 
		CanSwing = false
		SwingAvailability.hide()
	
	if SwingValue > 0.0 and Input.is_action_just_pressed("swing"):
		#Give impulse order according to swing potency
		Meteorite.impulse_self(SwingValue * MaxMeteorImpulsePotency)
		GameManager.add_stroke()
		
		SwingValue = 0.0
		DrivePowerDisplay.hide()
	elif !SwingingUp and CanSwing and Input.is_action_just_pressed("swing"):
		SwingingUp = true
		DrivePowerDisplay.show()

	if SwingingUp:
		SwingValue += delta
		SwingValue = clamp(SwingValue, 0.0, 1.0)
		DrivePowerDisplay.set_power_measure(SwingValue)
		if SwingValue == 1.0:
			SwingingUp = false
	elif SwingValue > 0.0:
		SwingValue -= delta
		SwingValue = clamp(SwingValue, 0.0, 1.0)
		DrivePowerDisplay.set_power_measure(SwingValue)
		if SwingValue == 0.0:
			DrivePowerDisplay.hide()
