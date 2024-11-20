extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

#Called from MainMenu Start button
func begin_game():
	GameManager.change_to_next_level()
