class_name StatusEffectsHandler
extends Node

var _active_status_effects: Array[StatusEffect]


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
