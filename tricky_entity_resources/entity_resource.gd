class_name EntityResource
extends Node

signal value_increased(new_value: float, delta_value: float)
signal value_decreased(new_value: float, delta_value: float)
signal value_reached_zero()
signal max_value_increased(new_max_value: float, delta_value: float)
signal max_value_decreased(new_max_value: float, delta_value: float)
signal auto_increment_started()
signal auto_increment_finished()
signal autodecrease_started()
signal autodecrease_finished()


@export var initial_value : float = 100.0 :
	set(new_value):
		pass
	get:
		return initial_value

@export var max_value : float = 100.0
@onready var _value : float = maxf(initial_value, 0.0)

@export_category("Auto-Inceremnt")
@export var auto_increment_enabled : bool = false 

@export_range(0.0, 1.0) var auto_increment_threshold : float = 1.0 : 
	set(new_value):
		auto_increment_threshold = clampf(new_value, 0.0, 1.0)
	get:
		return auto_increment_threshold

@export var auto_increment_value : float = 1.0 :
	set(new_value):
		auto_increment_value = maxf(new_value, 0.0)
	get:
		return auto_increment_value

@export var auto_increment_rate : float = 1.0 :
	set(new_value):
		auto_increment_rate = maxf(new_value, 0.0)
		_auto_increment_delay = _calculate_delay(auto_increment_rate)
		pass
	get:
		return auto_increment_rate

@export var auto_increment_start_delay : float = 1.0 : 
	set(new_value):
		auto_increment_start_delay = new_value
	get:
		return auto_increment_start_delay

@onready var _auto_increment_delay : float = _calculate_delay(auto_increment_rate)

var _auto_increment_start_delay_timer : Timer
var _auto_increment_timer : Timer 


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

	_auto_increment_timer = _create_timer("AutoIncrementTimer")
	_auto_increment_timer.timeout.connect(increase_value.bind(auto_increment_value, true))
	_auto_increment_start_delay_timer = _create_timer("AutoIncrementStartDelay")
	_auto_increment_start_delay_timer.timeout.connect(_start_auto_increment)
	pass


func increase_value(amount: float, clamp_to_max: bool = true) -> bool:
	if amount <= 0.0 || clamp_to_max && _value >= max_value:
		return false

	if clamp_to_max:
		var delta_value : int = max_value - _value
		amount = delta_value if delta_value < amount else amount

	_value += amount
	value_increased.emit(_value, amount)

	if get_relative_value() >= auto_increment_threshold:
		_auto_increment_timer.stop()
		_stop_auto_increament()

	return true


func decrease_value(amount: float) -> bool:
	if amount <= 0.0 || _value <= 0.0:
		return false

	amount = _value if amount > _value else amount
	_value -= amount
	value_decreased.emit(_value, amount)

	if get_relative_value() >= auto_increment_threshold:
		return true
	
	if auto_increment_start_delay > 0.0:
		_start_auto_increment_delay()
		return true
	
	_start_auto_increment()
	
	return true


func increase_max_value(amount : float, clamp_value: bool = false) -> bool:
	if amount <= 0.0 || max_value <= 0.0:
		return false

	max_value += amount
	max_value_increased.emit(amount)

	if clamp_value:
		var delta_value : int = max_value - _value
		increase_value(delta_value)

	return true


func decrease_max_value(amount : float, clamp_value: bool = true) -> bool:
	if amount <= 0.0 || max_value <= 0.0:
		return false

	amount = max_value if amount > max_value else amount
	max_value -= amount
	max_value_decreased.emit(amount)

	if clamp_value && _value > max_value:
		var delta_value : int = abs(max_value - _value)
		decrease_value(delta_value)

	return true


func get_relative_value() -> float:
	if max_value <= 0.0:
		return 0.0

	return _value / max_value


func _calculate_delay(rate : float) -> float:
	rate = max(rate, 0.0)

	if rate <= 0.0:
		return 1.0

	return 1.0 / rate


func _create_timer(name : String) -> Timer:
	var timer = Timer.new()
	timer.one_shot = false
	timer.autostart = false
	timer.name = name
	timer.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(timer)
	return timer


func _start_auto_increment_delay() -> void:
	if !_auto_increment_start_delay_timer.is_stopped():
		_auto_increment_start_delay_timer.stop()
	
	_auto_increment_start_delay_timer.start(auto_increment_start_delay)


func _start_auto_increment() -> void:
	if !_auto_increment_timer.is_stopped() || !auto_increment_enabled:
		return
	
	_auto_increment_timer.start(_auto_increment_delay)
	auto_increment_started.emit()

	
func _stop_auto_increament() -> void:
	if _auto_increment_timer.is_stopped():
		return

	_auto_increment_timer.stop()
	auto_increment_finished.emit()

func is_auto_increment_active() -> bool:
	return !_auto_increment_timer.is_stopped()