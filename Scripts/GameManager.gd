extends Node

#Global general purpose game managing class, mainly loads levels and controls game progression

enum GolfScore
{
	ALBATROSS,
	EAGLE,
	BIRDIE,
	PAR,
	BOGEY,
	DOUBLEBOGEY,
	TRIPLEBOGEY,
	GITGUD
}

var StrokesDisplay: Label = null

#Defininition of all of the game levels by index in array
var LevelPaths = [
				  "res://Levels/TutorialLevel.tscn",
				  "res://Levels/Level1.tscn",
				 ]
var CurrentLevelIndex = -1
var CurrentStrokes = 0
var MechanicsLocked = false
var Casualties = 0
var Destruction = 0

#Changes the current level for a specific one by index in array above
func change_to_level(index: int):
	CurrentLevelIndex = index
	get_tree().change_scene_to_file(LevelPaths[index])
	reset_game_status()

#Changes the current level for the next level available in LevelPaths array
func change_to_next_level():
	if CurrentLevelIndex == LevelPaths.size() - 1:
		change_to_main_menu()
	else:
		change_to_level((CurrentLevelIndex + 1) % LevelPaths.size())

func change_to_main_menu():
	CurrentLevelIndex = -1
	get_tree().change_scene_to_file("res://Levels/MainMenuScene.tscn")
	reset_game_status()

#Called from each level's Menu "ESC"
func reload_current_level():
	get_tree().reload_current_scene()
	reset_game_status()

func level_finished():
	if CurrentLevelIndex > 0:
		show_level_results()
		MechanicsLocked = true
	else:
		#Skip tutorial results
		change_to_next_level()

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

func add_destruction_points(destruction: int):
	Destruction += destruction

func reset_game_status():
	CurrentStrokes = 0
	MechanicsLocked = false
	Casualties = 0
	Destruction = 0
	
#Used for meteorite respawn requests
func respawn_meteorite(meteorite: RigidBody3D):
	var foundSpawnPoint = get_tree().get_root().get_node("Level/SpawnPoint").global_transform.origin
	#Stop it's momentum
	meteorite.angular_velocity = Vector3.ZERO
	meteorite.linear_velocity = Vector3.ZERO
	#Reposition at spawn point
	meteorite.global_transform.origin = foundSpawnPoint

func show_level_results():
	var FinalResults = get_tree().get_root().get_node("Level/FinalResults")
	StrokesDisplay.hide()
	
	var golfScore = GolfScore.GITGUD  # Default to GitGud if none of the conditions match

	if CurrentStrokes <= 1:
		golfScore = GolfScore.ALBATROSS
	elif CurrentStrokes == 2:
		golfScore = GolfScore.EAGLE
	elif CurrentStrokes == 3:
		golfScore = GolfScore.BIRDIE
	elif CurrentStrokes == 4:
		golfScore = GolfScore.PAR
	elif CurrentStrokes == 5:
		golfScore = GolfScore.PAR
	elif CurrentStrokes == 6:
		golfScore = GolfScore.BOGEY
	elif CurrentStrokes == 7:
		golfScore = GolfScore.DOUBLEBOGEY
	elif CurrentStrokes == 8:
		golfScore = GolfScore.TRIPLEBOGEY
	
	#Pacifist score = golfScore 0 to 8 points minus the destruction and casualties (x2)
	var pacifistScore = (8 - (golfScore + 1)) - Destruction - (Casualties * 2)
	if pacifistScore < 0: pacifistScore = 0
	
	var genocideScore = Destruction + (Casualties * 2)
	
	FinalResults.display(CurrentLevelIndex, CurrentStrokes, Destruction, golfScore, Casualties, pacifistScore, genocideScore)
