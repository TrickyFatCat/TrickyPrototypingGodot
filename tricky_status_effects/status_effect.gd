class_name StatusEffect
extends Resource

enum EffectType{
	POSITIVE,
	NEGATIVE,
	NEUTRAL
}

enum EffectUniqeness{
	NONE,
	PER_INSTIGATOR,
	PER_TARGET
}

@export var name : String = "StatusEffect"
@export var type : EffectType = EffectType.POSITIVE
@export var duration : float = 0.0

var _target : StatusEffectsHandler = null
var _instigator : Node = null


func activate_effect(target: StatusEffectsHandler, instigator: Node = null) -> bool:
	if !target:
		return false
	
	_target = target
	_instigator = instigator
	return true


func reactivate_effect() -> void:
	pass


func deactivate_effect() -> void:
	pass


func remove_effect() -> void:
	pass


func _handle_effect_activation() -> bool:
	return true


func _handle_effect_reactivation() -> void:
	pass


func _handle_effect_deactivation() -> void:
	pass


func _handle_effect_removal() -> void:
	pass
