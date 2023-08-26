extends Area3D

@export var DestructionPoints = 0.1

func on_body_entered(body: Node):
	GameManager.add_destruction_points(DestructionPoints)
	
	self.queue_free()
