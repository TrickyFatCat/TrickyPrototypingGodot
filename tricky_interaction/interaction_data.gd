class_name InteractionData
extends Resource

enum InteractionType{
	INSTANT,
	CAST,
	CUSTOM
}

@export var interaction_hint : String = "Interact"

@export var interaction_type : InteractionType = InteractionType.INSTANT

## Determined how long intercation lasts
## Used only with InteraractionType.TIMED
@export var interaction_duration : float = 0.0

## Used for sorting in the interaction queue
@export var interaction_weight : int = 1


func _init(hint: String, type : InteractionType, duration : float, weight: int) -> void:
	resource_local_to_scene = true 
	interaction_hint = hint
	interaction_type = type
	interaction_duration = duration
	interaction_duration = max(interaction_duration, 0.0)
	interaction_weight = weight