extends Node

#Global general purpose game managing class, mainly loads levels and controls game progression

var StrokesDisplay: Label = null

#Defininition of all of the game levels by index in array
var LevelPaths = [
				  "res://Levels/MainMenu.tscn",
				  "res://Levels/TutorialLevel.tscn",
				  "res://Levels/Level1.tscn"
				 ]
var CurrentLevelIndex = 0
var CurrentStrokes = 0

#Changes the current level for a specific one by index in array above
func change_to_level(index: int):
	CurrentLevelIndex = index
	get_tree().change_scene_to_file(LevelPaths[index])
	reset_game_status()

#Called from each level's Menu "ESC"
func reload_current_level():
	get_tree().reload_current_scene()
	reset_game_status()
	
#Changes the current level for the next level available in LevelPaths array
func change_to_next_level():
	change_to_level((CurrentLevelIndex + 1) % LevelPaths.size())

func add_stroke():
	CurrentStrokes += 1
	if StrokesDisplay != null:
		StrokesDisplay.text = "Strokes: " + str(CurrentStrokes)
	else:
		StrokesDisplay = get_tree().get_root().get_node("Level/HUD/Strokes")
		if StrokesDisplay:
			StrokesDisplay.text = "Strokes: " + str(CurrentStrokes)

func get_strokes():
	return CurrentStrokes
	
func reset_game_status():
	CurrentStrokes = 0

#Used for meteorite respawn requests
func respawn_meteorite(meteorite: RigidBody3D):
	var foundSpawnPoint = get_tree().get_root().get_node("Level/SpawnPoint").global_transform.origin
	#Stop it's momentum
	meteorite.angular_velocity = Vector3.ZERO
	meteorite.linear_velocity = Vector3.ZERO
	#Reposition at spawn point
	meteorite.global_transform.origin = foundSpawnPoint
