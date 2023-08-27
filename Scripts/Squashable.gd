extends Area3D

@export var DestructionPoints = 0.0
@export var CasualtyPoints = 0.0

func on_body_entered(_body: Node):
	GameManager.add_destruction_points(DestructionPoints)
	GameManager.add_casualty_points(CasualtyPoints)
	
	self.queue_free()

func on_timer_timeout():
	pass # Replace with function body.
