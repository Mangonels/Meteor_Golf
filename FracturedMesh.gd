@tool
extends Node3D

@export var create_rigids = false : set = _create_rigids
@export var get_shard_positions = false : set = _get_shard_positions
@export var reset = false : set = _reset

var shard_positions = {}

func _process(delta):
	if Engine.is_editor_hint():
		if Input.is_key_pressed(KEY_P):
			print("on")
			set_physics_process(true)
		elif Input.is_key_pressed(KEY_N):
			print("off")
			set_physics_process(false)
			
func _get_shard_positions(_value):
	shard_positions = {}
	for shard in $Shards.get_children():
		shard_positions[shard] = [shard.transform.origin, shard.rotation_degrees]
	print("Positions registered.")
		
func _reset(_value):
	for shard in $Shards.get_children():
		shard.transform.origin = shard_positions[shard][0]
		shard.rotation_degrees = shard_positions[shard][1]
	print("Reset Positions")
		
func _create_rigids(_value):
	if Engine.is_editor_hint():
		for node in $Shards.get_children():
			if node.name.find("cell") != -1:
				var rigidbodyInstance = load("res://RigidBody.tscn").instantiate()

				rigidbodyInstance.transform.origin = node.transform.origin
				rigidbodyInstance.scale = Vector3(1,1,1)

				$Shards.add_child(rigidbodyInstance)
				rigidbodyInstance.set_owner(get_tree().get_edited_scene_root())

				var meshNode = node

				$Shards.remove_child(node)

				meshNode.transform.origin = Vector3(0,0,0)
				meshNode.scale = Vector3(1,1,1)

				rigidbodyInstance.add_child(meshNode)

				meshNode.set_owner(get_tree().get_edited_scene_root())


				# creates a static body with collision shape
				# mesh/static body/collision shape
				meshNode.create_convex_collision()

				# grabs newly created collision shape
				var collisionNode = meshNode.get_child(0).get_child(0)

				# removes collision shape
				rigidbodyInstance.get_child(0).get_child(0).remove_child(meshNode.get_child(0).get_child(0))
				# removes static body
				rigidbodyInstance.get_child(0).remove_child(meshNode.get_child(0))

				# re-adds the collision shape, this as a direct child of the rigid body
				rigidbodyInstance.add_child(collisionNode)

				collisionNode.set_owner(get_tree().get_edited_scene_root())
