extends Node2D
## moved to interaction manager
@onready var interaction_area : Area2D = $InteractionArea
@onready var interact_label : Label = $InteractLabel
var current_interactions := []
var can_interact := true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and can_interact:
		if current_interactions:
			can_interact = false
			interact_label.visible = false
			
			await current_interactions[0].interact.call()
			
			can_interact = true

func _ready() -> void:
	interact_label.visible = false
	interaction_area.area_entered.connect(_on_interact_area_entered)
	interaction_area.area_exited.connect(_on_interact_area_exited)

func _process(_delta : float) -> void:
	if current_interactions and can_interact:
		current_interactions.sort_custom(_sort_by_nearest)
		if current_interactions[0].is_interactable:
			interact_label.text = current_interactions[0].interact_name
			interact_label.visible = true
	else:
		interact_label.visible = false

func _on_interact_area_entered(area : Area2D) -> void:
	current_interactions.push_back(area)

func _on_interact_area_exited(area : Area2D) -> void:
	current_interactions.erase(area)

func _sort_by_nearest(area_1, area_2):
	var area_1_distance = global_position.distance_to(area_1.global_position)
	var area_2_distance = global_position.distance_to(area_2.global_position)
	
	return area_1_distance > area_2_distance
