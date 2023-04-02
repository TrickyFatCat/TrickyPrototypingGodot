class_name PickupEffectsHandler
extends Node

signal effect_activated(effect: PickupEffect)

@export var main_effect: PickupEffect
@export var secondary_effects: Array[PickupEffect]


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

func activate(target: Node = null) -> bool:
	if !main_effect:
		return false

	if !main_effect.activate(target):
		return false

	if !secondary_effects.is_empty():
		for effect in secondary_effects:
			if !effect:
				continue
			
			effect.activate(target)

	return true
