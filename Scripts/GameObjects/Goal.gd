extends Area3D

func on_body_entered(body):
	GameManager.level_finished()
	$LevelFinishedEffect/CPU3D_Bubbles.emitting = true
	$LevelFinishedEffect/CPU3D_LightRays.emitting = true
