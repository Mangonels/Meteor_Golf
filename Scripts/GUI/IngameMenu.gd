extends Control

@onready var CameraScript: Node3D = get_tree().get_root().get_node("Level/OrbitalFollowCamera")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hide()

func _process(_delta):
	if Input.is_action_just_pressed("toggle_menu"):
		if is_visible():
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			CameraScript.OrbitingEnabled = true
			hide()
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			CameraScript.OrbitingEnabled = false
			show()

func restart_level():
	GameManager.reload_current_level()
	
func return_to_main_menu():
	GameManager.change_to_main_menu()
