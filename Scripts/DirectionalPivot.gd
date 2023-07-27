extends Node3D

@onready var Meteorite: Node = get_tree().get_root().get_node("Level/MeteoriteBall")

func _process(delta):
	transform.origin = Meteorite.transform.origin 
