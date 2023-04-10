class_name StatusEffectsHandler
extends Node

signal status_effect_applied(effect: StatusEffect, instigator: Node)

var _active_status_effects: Array[StatusEffect]


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


func apply_status_effect(effect : StatusEffect, instigator : Node = null) -> StatusEffect:
	if !StatusEffect:
		return null

	var status_effect : StatusEffect = null

	match effect.uniqueness:
		effect.EffectUniqeness.PER_INSTIGATOR:
			status_effect = get_status_effect_by_instigator(effect, instigator)
			pass
		
		effect.EffectUniqeness.PER_TARGET:
			status_effect = get_status_effect_by_class(effect)
			pass

	if status_effect:
		status_effect.reactivate()
		return status_effect

	status_effect = effect.duplicate()

	if !status_effect.activate(self, instigator):
		return null

	_active_status_effects.push_front(status_effect)
	status_effect.deactivated.connect(_handle_effect_deactivation.bind(status_effect))
	status_effect_applied.emit(status_effect, instigator)
	return status_effect


func remove_satus_effect_by_class(effect: StatusEffect) -> bool:
	if !effect:
		return false

	var status_effect : StatusEffect = get_status_effect_by_class(effect)

	if !status_effect:
		return false
	
	status_effect.deactivate()
	return true

func get_status_effect_by_class(effect: StatusEffect) -> StatusEffect:
	var result_effect : StatusEffect = null

	if !effect:
		return result_effect

	var predicate := func(a : StatusEffect) : return a.get_class() == effect.get_class()
	var effect_index : int = _active_status_effects.find(predicate)

	if effect_index >= 0:
		result_effect = _active_status_effects[effect_index]

	return result_effect


func get_status_effect_by_instigator(effect: StatusEffect, instigator: Node) -> StatusEffect:
	var result_effect : StatusEffect = null

	if !effect:
		return result_effect

	var predicate := func(a : StatusEffect): 
		return a.get_class() == effect.get_class() && a._instigator == instigator
	var effect_index : int = _active_status_effects.find(predicate)

	if effect_index >= 0:
		result_effect = _active_status_effects[effect_index]
	
	return result_effect


func _handle_effect_deactivation(effect: StatusEffect) -> void:
	if !effect:
		return

	_active_status_effects.erase(effect)