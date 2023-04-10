class_name StatusEffect
extends Resource

signal deactivated
signal reactivated

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

enum ReactivationBehavior{
	NONE,
	RESET,
	ADD,
	CUSTOM
}

@export var name : String = "StatusEffect"
@export var type : EffectType = EffectType.POSITIVE
@export var duration : float = 0.0
@export var uniqueness : EffectUniqeness = EffectUniqeness.PER_INSTIGATOR
@export var reactivation_behavior : ReactivationBehavior = ReactivationBehavior.RESET

var _target : StatusEffectsHandler = null
var _instigator : Node = null
var _duration_timer : Timer = null


func activate(target: StatusEffectsHandler, instigator: Node = null) -> bool:
	if !target:
		return false
	
	_target = target
	_instigator = instigator
	
	if duration > 0:
		_duration_timer = Timer.new()
		_duration_timer.one_shot = true
		_duration_timer.autostart = false
		_duration_timer.wait_time = duration
		_duration_timer.timeout.connect(deactivate)
		_target.add_child(_duration_timer)
		
	_handle_activation()
	return true


func reactivate() -> void:
	if _duration_timer && !_duration_timer.is_stopped():
		match reactivation_behavior:
			ReactivationBehavior.RESET:
				_duration_timer.wait_time = duration
				pass
			
			ReactivationBehavior.ADD:
				_duration_timer.wait_time += duration
				pass

	_handle_reactivation()
	reactivated.emit()
	pass


func deactivate() -> void:
	_handle_deactivation()
	deactivated.emit()
	_duration_timer.queue_free()
	pass


func get_time_left() -> float:
	if !_duration_timer:
		return -1.0

	return _duration_timer.time_left


func _handle_activation() -> bool:
	return true


func _handle_reactivation() -> void:
	pass


func _handle_deactivation() -> void:
	pass

