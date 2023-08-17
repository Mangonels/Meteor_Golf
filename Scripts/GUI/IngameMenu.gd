extends Control

@onready var CameraScript: Node3D = get_tree().get_root().get_node("Level/OrbitalFollowCamera")

func _ready():
	Input.mouse_mode = 2
	hide()

func _process(delta):
	if Input.is_action_just_pressed("toggle_menu"):
		if is_visible():
			Input.mouse_mode = 2
			CameraScript.OrbitingEnabled = true
			hide()
		else:
			Input.mouse_mode = 0
			CameraScript.OrbitingEnabled = false
			show()

func restart_level():
	GameManager.reload_current_level()
	
func return_to_main_menu():
	GameManager.change_to_main_menu()
