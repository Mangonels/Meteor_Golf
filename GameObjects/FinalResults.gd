extends Control

@export var ResultsDisplay: Label = null

func _ready():
	hide()

func _process(delta):
	if is_visible() and ( Input.is_action_just_pressed("submit") or Input.is_action_just_pressed("swing") ):
		hide()
		GameManager.change_to_next_level()

func display(strokes: int, destruction: int, golf_score: GameManager.GolfScore, casualties: int, pacifist_score: int, genocide_score: int):
	ResultsDisplay.text = "Strokes: " + str(strokes) + "\n" + "Destruction: " + str(destruction) + "\n" + "Golf Score: " + str(golf_score) + "\n" + "Casualties: " + str(casualties) + "\n" + "Pacifist Score: " + str(pacifist_score) + "\n" + "Genocide Score: " + str(genocide_score)
	show()
