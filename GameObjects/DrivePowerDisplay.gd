extends Control

var MIN_X_POS = -164
var MAX_X_POS = 182

@export var PowerMeasure: ColorRect = null

func set_power_measure(val: float):
	PowerMeasure.position.x = lerp(MIN_X_POS, MAX_X_POS, val)
