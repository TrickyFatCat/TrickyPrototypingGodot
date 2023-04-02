class_name InteractionHandler
extends Node

@export var interaction_data : InteractionData

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


func start_interaction(interactor: InteractionQueue) -> bool:
	if !interactor:
		return false

	return true;


func stop_interaction(interactor: InteractionQueue) -> bool:
	return true


func finish_interaction(interactor: InteractionQueue) -> bool:
	if !interactor:
		return false

	return true