extends Area3D

@export var TeleportTarget: Node3D = null

func on_body_entered(body: Node):
	body.linear_velocity = Vector3.ZERO
	body.angular_velocity = Vector3.ZERO

	body.transform.origin = TeleportTarget.global_transform.origin
