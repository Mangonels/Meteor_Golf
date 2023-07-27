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
	print("changing to level: " + str(CurrentLevelIndex))
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
		var node_path = "Level/HUD/Strokes"
		StrokesDisplay = get_tree().get_root().get_node(node_path)
		if StrokesDisplay:
			StrokesDisplay.text = "Strokes: " + str(CurrentStrokes)

func get_strokes():
	return CurrentStrokes
	
func reset_game_status():
	CurrentStrokes = 0
