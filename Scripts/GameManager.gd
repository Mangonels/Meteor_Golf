extends Node

#Global general purpose game managing class, mainly loads levels and controls game progression

#Defininition of all of the game levels by index in array
var LevelPaths = [
				  "res://Levels/MainMenu.tscn",
				  "res://Levels/TutorialLevel.tscn",
				  "res://Levels/Level1.tscn"
				 ]
var CurrentLevelIndex = 0

#Changes the current level for a specific one by index (view array above)
func change_to_level(index: int):
	CurrentLevelIndex = index
	get_tree().change_scene_to_file(LevelPaths[index])

#Called from each level's Menu "ESC"
func reload_current_level():
	get_tree().reload_current_scene()

#Changes the current level for the next level available in LevelPaths array
func change_to_next_level():
	change_to_level((CurrentLevelIndex + 1) % LevelPaths.size())
