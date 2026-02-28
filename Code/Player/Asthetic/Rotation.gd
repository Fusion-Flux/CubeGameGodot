extends Node3D


@export var is_player = true

@export var core_array: Array[Node3D] = []
@export var outline_array: Array[Node3D] = []
@export var decor_array: Array[Node3D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_is_player():
	return is_player

func get_cores():
	return core_array
	
func get_outlines():
	return outline_array

func get_decor():
	return decor_array

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !is_player:
		rotate(Vector3.UP,.01)
	pass
