class_name Keyring
extends Node

## Node which handles lock keys

signal lock_key_added(lock_key : LockKey)
signal lock_key_used(lock_key : LockKey)
signal lock_key_removed(lock_key: LockKey)

var _lock_keys : Array[LockKey] = []


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


## Adds a new lock key to the key array
func add_lock_key(new_lock_key : LockKey) -> bool:
	if !new_lock_key:
		return false

	if new_lock_key.is_unique && has_lock_key(new_lock_key):
		return false

	_lock_keys.push_back(new_lock_key.duplicate())
	lock_key_added.emit(new_lock_key)
	return true


## Uses the first lock key in the collection.
func use_lock_key(target_lock_key : LockKey) -> bool:
	if !target_lock_key || !has_lock_key(target_lock_key):
		return false

	var lock_key : LockKey = get_lock_key(target_lock_key)

	if !lock_key:
		return false

	lock_key_used.emit(lock_key)

	if lock_key.destroy_on_use:
		lock_key_removed.emit(lock_key)
		_lock_keys.erase(lock_key)
		
	return true


## Removes first lock key of a given class from the array
func remove_key(target_lock_key : LockKey) -> bool:
	if !target_lock_key || !has_lock_key(target_lock_key):
		return false

	var lock_key : LockKey = get_lock_key(target_lock_key)

	if !lock_key:
		return false

	lock_key_removed.emit(lock_key)
	_lock_keys.erase(lock_key)

	return true


## Removes all the lock keys in the array
func remove_all_keys() -> bool:
	if _lock_keys.is_empty():
		return false

	_lock_keys.clear()
	return true


## Removes all the lock keys of a given class
func remove_all_keys_of_class(target_lock_key : LockKey) -> bool:
	if !target_lock_key || !has_lock_key(target_lock_key):
		return false

	var predicate := func(key : LockKey): return key.get_class() != target_lock_key.get_class()
	var new_array : Array[LockKey]= _lock_keys.filter(predicate)
	_lock_keys = new_array
	return true


## Checks if a lock key of a give class is in the array
func has_lock_key(target_lock_key : LockKey) -> bool:
	if !target_lock_key || _lock_keys.is_empty():
		return false

	var predicate := func(lock_key : LockKey): return lock_key.get_class() == target_lock_key.get_class()
	return _lock_keys.any(predicate)


## Returns the first lock key of a given class
func get_lock_key(target_lock_key : LockKey) -> LockKey:
	if !target_lock_key || !has_lock_key(target_lock_key) || _lock_keys.is_empty():
		return null

	var predicate := func(lock_key : LockKey): return lock_key.get_class() == target_lock_key.get_class()
	return _lock_keys.filter(predicate)[0]


## Returns number of lock keys of a given class
func get_lock_key_num(target_lock_key: LockKey) -> int:
	if !target_lock_key || !has_lock_key(target_lock_key):
		return false

	var predicate := func(lock_key: LockKey): return lock_key.get_class() == target_lock_key.get_class()
	return _lock_keys.filter(predicate).size()