extends Area3D

@export var FracturedResourceHigh: Resource
@export var FracturedResourceLow: Resource
@export var DestructionPoints = 1

func on_body_entered(_body: Node):
	var fracturedModel
	if OS.has_feature("windows"):
		fracturedModel = FracturedResourceHigh.instantiate()
	elif OS.has_feature("web"):
		fracturedModel = FracturedResourceLow.instantiate()

	self.get_parent().add_child(fracturedModel)
	
	fracturedModel.transform.origin = self.transform.origin
	fracturedModel.rotation_degrees = self.rotation_degrees
	fracturedModel.scale = self.scale
	
	GameManager.add_destruction_points(DestructionPoints)

	self.queue_free()
