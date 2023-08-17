extends Control

func _ready():
	Input.mouse_mode = 0

#Called from MainMenu Start button
func begin_game():
	GameManager.change_to_next_level()
