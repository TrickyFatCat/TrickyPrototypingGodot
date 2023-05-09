class_name StatusEffect
extends Resource

signal deactivated(reason : DeactivationReason)
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

enum DeactivationReason{
	TIME,
	STACKS,
	REMOVAL
}

@export var name : String = "StatusEffect"
@export var type : EffectType = EffectType.POSITIVE
@export var uniqueness : EffectUniqeness = EffectUniqeness.PER_INSTIGATOR
@export var duration : float = 0.0
@export var duration_reactivation_behavior : ReactivationBehavior = ReactivationBehavior.RESET
@export var is_stackable : bool = false
@export var stacks_reactivation_behavior : ReactivationBehavior = ReactivationBehavior.ADD
@export var initial_stacks : int = 1
@export var max_stacks : int = 1
@export var delta_stacks : int = 1

var _target : StatusEffectsHandler = null
var _instigator : Node = null
var _duration_timer : Timer = null
var _current_stacks : int =  1


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
		_duration_timer.timeout.connect(deactivate.bind(DeactivationReason.TIME))
		_target.add_child(_duration_timer)

	if is_stackable:
		_current_stacks = initial_stacks
		
	_handle_activation()
	return true


func reactivate() -> void:
	if _duration_timer && !_duration_timer.is_stopped():
		match duration_reactivation_behavior:
			ReactivationBehavior.RESET:
				_duration_timer.wait_time = duration
				pass
			
			ReactivationBehavior.ADD:
				_duration_timer.wait_time += duration
				pass

	if is_stackable:
		match stacks_reactivation_behavior:
			ReactivationBehavior.RESET:
				_current_stacks = initial_stacks
				pass
			
			ReactivationBehavior.ADD:
				increase_stacks(delta_stacks)
				pass

	_handle_reactivation()
	reactivated.emit()
	pass


func deactivate(reason : DeactivationReason) -> void:
	_handle_deactivation(reason)
	deactivated.emit(reason)
	_duration_timer.queue_free()
	pass


func increase_stacks(amount : int = 1) -> void:
	if amount <= 0 || _current_stacks >= max_stacks:
		return
	
	_current_stacks = min(_current_stacks + amount, max_stacks)
	_handle_stacks_increment(amount)


func decrease_satcks(amount : int = 1) -> void:
	if amount <= 0:
		return
	
	_current_stacks = max(_current_stacks - amount, 0)
	_handle_stacks_decrement(amount)

	if _current_stacks <= 0:
		deactivate(DeactivationReason.STACKS)


func get_time_left() -> float:
	if !_duration_timer:
		return -1.0

	return _duration_timer.time_left


func _handle_activation() -> bool:
	return true


func _handle_reactivation() -> void:
	pass


func _handle_deactivation(reason : DeactivationReason) -> void:
	pass


func _handle_stacks_increment(amount : int) -> void:
	pass


func _handle_stacks_decrement(amount : int) -> void:
	pass