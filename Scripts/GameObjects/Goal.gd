extends Area3D

func on_body_entered(_body):
	$LevelFinishedEffect/CPU3D_Bubbles.emitting = true
	$LevelFinishedEffect/CPU3D_LightRays.emitting = true
	GameManager.level_finished()
