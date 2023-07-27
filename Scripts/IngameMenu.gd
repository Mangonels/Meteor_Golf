extends Control

func _ready():
	Input.mouse_mode = 2
	hide()

func _process(delta):
	if Input.is_action_just_pressed("toggle_menu"):
		if is_visible():
			Input.mouse_mode = 2
			hide()
		else:
			Input.mouse_mode = 0
			show()

func restart_level():
	GameManager.reload_current_level()
	
func return_to_main_menu():
	GameManager.change_to_level(0)
