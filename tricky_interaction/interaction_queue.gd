class_name InteractionQueue
extends Node

var _interaction_queue : Array[InteractionHandler]
var _interaction_target : InteractionHandler
var _interaction_timer : Timer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

	_interaction_timer = Timer.new()
	_interaction_timer.one_shot = true
	_interaction_timer.auto_start = false
	_interaction_timer.name = "InteractionTimer"
	_interaction_timer.timeout.connect(finish_interaction.bind(self))
	add_child(_interaction_timer)


func add_to_queue(handler: InteractionHandler) -> void:
	if !handler || !is_in_queue(handler) || !handler.interaction_data:
		return

	_interaction_queue.push_back(handler)
	handler.tree_exiting.connect(remove_from_queue.bind(handler))
	_sort_queue()


func remove_from_queue(handler: InteractionHandler) -> void:
	if !handler || !is_in_queue(handler):
		return

	_interaction_queue.erase(handler)
	_sort_queue()


func is_in_queue(handler: InteractionHandler) -> bool:
	if !handler || _interaction_queue.is_empty():
		return false

	return _interaction_queue.has(handler)


func start_interaction() -> bool:
	if _interaction_queue.is_empty():
		return false
		
	_interaction_target = _get_interaction_target() 

	if !_interaction_target:
		return false

	var interaction_type : InteractionData.InteractionType = _interaction_target.interaction_data.interaction_type

	match interaction_type:
		InteractionData.InteractionType.INSTANT:
			if !_interaction_target.start_interaction(self):
				return false
			return finish_interaction()
			pass

		InteractionData.InteractionType.CAST:
			if !_interaction_target.start_interaction(self):
				return false
			
			_interaction_timer.start(_interaction_target.interaction_data.interaction_duration)
			pass

	return _interaction_target.start_interaction(self)


func stop_interaction() -> bool:
	if _interaction_queue.is_empty():
		return false

	if !_interaction_target:
		return false

	return _interaction_target.stop_interaction(self)


func finish_interaction() -> bool:
	if _interaction_queue.is_empty():
		return false

	if !_interaction_target:
		return false
	
	return _interaction_target.finish_interaction(self)


func _sort_queue() -> void:
	if _interaction_queue.is_empty():
		return

	var predicate := func(a : InteractionHandler, b : InteractionHandler): return a.interaction_data.interaction_weight > b.interaction__data.interaction_weight
	_interaction_queue.sort_custom(predicate)


func _get_interaction_target() -> InteractionHandler:
	if _interaction_queue.is_empty():
		return null

	return _interaction_queue[0]