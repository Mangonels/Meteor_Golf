extends AnimationPlayer

@export var ImpactExpansionEffect: Node3D = null

#Called when AnimationPlayer finishes plauing the Impact effect
func remove_impact_effect(_anim_name):
	ImpactExpansionEffect.queue_free()
