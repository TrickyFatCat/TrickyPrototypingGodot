@tool
class_name InteractionHandler
extends Node

signal interaction_started(interactor: InteractionQueue)
signal interaction_stopped(interactor: InteractionQueue)
signal interaction_finished(interactor: InteractionQueue)

@export var interaction_data : InteractionData

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


func start_interaction(interactor: InteractionQueue) -> bool:
	if !interactor:
		return false

	interaction_started.emit(interactor)
	return true;


func stop_interaction(interactor: InteractionQueue) -> bool:
	interaction_stopped.emit(interactor)
	return true


func finish_interaction(interactor: InteractionQueue) -> bool:
	if !interactor:
		return false

	interaction_finished.emit(interactor)
	return true

func _get_configuration_warnings() -> PackedStringArray:
	if !interaction_data:
		return ["Interaction data is not created."]
	
	return []