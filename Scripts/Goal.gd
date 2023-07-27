extends Area3D

func on_body_entered(body):
	GameManager.change_to_next_level()
