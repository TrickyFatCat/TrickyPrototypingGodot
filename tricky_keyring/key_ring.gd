class_name KeyRing
extends Node

signal lock_key_added(lock_key : LockKey)
signal lock_key_used(lock_key : LockKey)
signal lock_key_removed(lock_key: LockKey)

var _lock_keys : Array[LockKey] = []


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


func add_lock_key(new_lock_key : LockKey) -> bool:
	if !new_lock_key:
		return false

	if new_lock_key.is_unique && has_lock_key(new_lock_key):
		return false

	_lock_keys.push_back(new_lock_key.duplicate())
	lock_key_added.emit(new_lock_key)
	return true


func use_lock_key(target_key : LockKey) -> bool:
	if !target_key || !has_lock_key(target_key):
		return false

	var lock_key : LockKey = get_lock_key(target_key)

	if !lock_key:
		return false

	lock_key_used.emit(lock_key)

	if lock_key.destroy_on_use:
		lock_key_removed.emit(lock_key)
		_lock_keys.erase(lock_key)
		
	return true


func remove_lock_key(target_key : LockKey) -> bool:
	if !target_key || !has_lock_key(target_key):
		return false

	var lock_key : LockKey = get_lock_key(target_key)

	if !lock_key:
		return false

	lock_key_removed.emit(lock_key)
	_lock_keys.erase(lock_key)

	return true


func has_lock_key(target_key : LockKey) -> bool:
	if !target_key || _lock_keys.is_empty():
		return false

	var predicate = func(lock_key : LockKey): return lock_key.get_class() == target_key.get_class()
	return _lock_keys.any(predicate)


func get_lock_key(target_key : LockKey) -> LockKey:
	if !target_key || !has_lock_key(target_key) || _lock_keys.is_empty():
		return null

	var predicate = func(lock_key : LockKey): return lock_key.get_class() == target_key.get_class()
	return _lock_keys.filter(predicate)[0]