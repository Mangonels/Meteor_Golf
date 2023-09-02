extends Area3D

@export var HighFracturedResource: PackedScene
@export var LowFracturedResource: PackedScene

@export var RemoveNodeTrees: Array[Node3D]

@export var DestructionPoints = 1

func on_body_entered(_body: Node):
	var fracturedModel
	if OS.has_feature("windows"):
		fracturedModel = HighFracturedResource.instantiate()
	elif OS.has_feature("web"):
		fracturedModel = LowFracturedResource.instantiate()

	self.get_parent().add_child(fracturedModel)
	
	fracturedModel.transform.origin = self.transform.origin
	fracturedModel.rotation_degrees = self.rotation_degrees
	fracturedModel.scale = self.scale
	
	GameManager.add_destruction_points(DestructionPoints)

	for node in RemoveNodeTrees:
		if node is Node:
			node.queue_free()

	self.queue_free()
