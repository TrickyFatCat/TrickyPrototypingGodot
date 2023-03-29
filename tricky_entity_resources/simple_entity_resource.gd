class_name SimpleEntityResource
extends Node

## Simple node to create and implement simple resource like counters of coins or score

signal value_increased(new_value: int, delta_value: int)
signal value_decreased(new_value: int, delta_value: int)
signal value_reached_zero()
signal max_value_increased(new_max_value: int, delta_value: int)
signal max_value_decreased(new_max_value: int, delta_value: int)


@export var initial_value : int = 100
@export var max_value : int = 100
@onready var _value : int = max(initial_value, 0)

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	pass 


func increase_value(amount: int, clamp_to_max: bool = true) -> bool:
	if amount <= 0 || clamp_to_max && _value >= max_value:
		return false

	if clamp_to_max:
		var delta_value : int = max_value - _value
		amount = delta_value if amount > delta_value else amount

	_value += amount
	value_increased.emit(_value, amount)

	return true


func decrease_value(amount: int) -> bool:
	if amount <= 0 || _value <= 0:
		return false

	amount = _value if amount > _value else amount
	_value -= amount
	value_decreased.emit(_value, amount)
	
	if _value <= 0:
		value_reached_zero.emit()

	return true


func increase_max_value(amount: int, clamp_value: bool = false) -> bool:
	if amount <= 0:
		return false

	max_value += amount
	max_value_increased.emit(max_value, amount)

	if clamp_value:
		var delta_value : int = max_value - _value
		increase_value(delta_value)

	return true


func decrease_max_value(amount: int, clamp_value: bool = true) -> bool:
	if amount <= 0 || max_value <= 0:
		return false

	amount = max_value if amount > max_value else amount
	max_value -= amount
	max_value_decreased.emit(max_value, amount)

	if clamp_value:
		var delta_value : int = abs(max_value - _value)
		decrease_value(delta_value)

	return true


func get_relative_value() -> float:
	if max_value == 0:
		return 0

	return float(_value) / float(max_value)
