class_name LockKey
extends Resource

## A class which contains lock key data

@export var name : String = "LockKey Name"
@export_color_no_alpha var color : Color = Color.RED

## If true, the key will be destroyed on use_lock_key call in Keyring
@export var destroy_on_use : bool = false

## If true, only one key can be stored in Keyring
@export var is_unique : bool = true