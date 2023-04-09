class_name StatusEffect
extends Resource

signal deactivated

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
@export var uniqueness : EffectUniqeness = EffectUniqeness.PER_INSTIGATOR

var _target : StatusEffectsHandler = null
var _instigator : Node = null
var _duration_timer : SceneTreeTimer = null


func activate(target: StatusEffectsHandler, instigator: Node = null) -> bool:
	if !target:
		return false
	
	_target = target
	_instigator = instigator
	
	if duration > 0:
		_duration_timer = _target.get_tree().create_timer(duration)
		_duration_timer.timeout.connect(deactivate)
		
	_handle_activation()
	return true


func reactivate() -> void:
	_handle_reactivation()
	pass


func deactivate() -> void:
	_handle_deactivation()
	deactivated.emit()
	pass


func _handle_activation() -> bool:
	return true


func _handle_reactivation() -> void:
	pass


func _handle_deactivation() -> void:
	pass

