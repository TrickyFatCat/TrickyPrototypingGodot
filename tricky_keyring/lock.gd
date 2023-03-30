class_name Lock
extends Node

signal unlocked()
signal locked()

@export var is_locked : bool = true
@export var required_key : LockKey

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


func unlock(keyring: Keyring) -> bool:
	if !keyring || keyring.use_lock_key(required_key):
		return false

	is_locked = false
	unlocked.emit()
	return true


func lock(keyring: Keyring, use_key : bool = false) -> bool:
	if !use_key:
		is_locked = true
		locked.emit()
		return true

	if !keyring || !keyring.use_lock_key(required_key):
		return false

	is_locked = true
	locked.emit()
	return true
