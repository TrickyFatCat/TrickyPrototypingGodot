class_name EntityResource
extends Node

signal value_increased(new_value: float, delta_value: float)
signal value_decreased(new_value: float, delta_value: float)
signal value_reached_zero()
signal max_value_increased(new_max_value: float, delta_value: float)
signal max_value_decreased(new_max_value: float, delta_value: float)
signal autoincrease_started()
signal autoincrease_finished()
signal autodecrease_started()
signal autodecrease_finished()


@export var initial_value : float = 100.0 :
	set(new_value):
		pass
	get:
		return initial_value

@export var max_value : float = 100.0 :
	set(new_value):
		pass
	get:
		return max_value

@onready var value : float = maxf(initial_value, 0.0) :
	set(new_value):
		pass
	get:
		return value


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	pass


func increase_value(amount: float, clamp_to_max: bool = true) -> bool:
	if amount <= 0.0 || clamp_to_max && value >= max_value:
		return false

	if clamp_to_max:
		var delta_value : int = max_value - value
		amount = delta_value if delta_value < amount else amount

	value += amount
	value_increased.emit(value, amount)
	return true


func decrease_value(amount: float) -> bool:
	if amount <= 0.0 || value <= 0.0:
		return false

	amount = value if amount > value else amount
	value -= amount
	value_decreased.emit(value, amount)
	return true


func increase_max_value(amount : float, clamp_value: bool = false) -> bool:
	if amount <= 0.0 || max_value <= 0.0:
		return false

	max_value += amount
	max_value_increased.emit(amount)

	if clamp_value:
		var delta_value : int = max_value - value
		increase_value(delta_value)

	return true


func decrease_max_value(amount : float, clamp_value: bool = true) -> bool:
	if amount <= 0.0 || max_value <= 0.0:
		return false

	amount = max_value if amount > max_value else amount
	max_value -= amount
	max_value_decreased.emit(amount)

	if clamp_value && value > max_value:
		var delta_value : int = abs(max_value - value)
		decrease_value(delta_value)

	return true


func get_relative_value() -> bool:
	if max_value <= 0.0:
		return 0.0

	return value / max_value