extends Control

@export var ResultsDisplay: Label = null
@export var FontSize = 30

func _ready():
	hide()

func _process(_delta):
	if is_visible() and ( Input.is_action_just_pressed("submit") or Input.is_action_just_pressed("swing") ):
		hide()
		GameManager.change_to_next_level()

func display(level: int, strokes: int, destruction: int, golf_score: GameManager.GolfScore, casualties: int, pacifist_score: int, genocide_score: int):
	ResultsDisplay.add_theme_font_size_override("font_size", FontSize)
	ResultsDisplay.text = "LEVEL " + str(level) + " RESULTS" + "\n\n" + "Strokes: " + str(strokes) + "\n" + "Destruction: " + str(destruction) + "\n" + "Golf Score: " + GameManager.GolfScore.keys()[golf_score] + "\n" + "Casualties: " + str(casualties) + "\n" + "Pacifist Score: " + str(pacifist_score) + "\n" + "Genocide Score: " + str(genocide_score)
	show()
