extends Timer

@export var TheAnimationPlayer: AnimationPlayer = null

@export var RandomMax = 1.0
@export var RandomMin = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	wait_time = randf_range(RandomMin, RandomMax)
	start()

func on_timer_timeout():
	TheAnimationPlayer.play("Human_Animation")
