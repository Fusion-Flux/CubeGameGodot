extends Node3D


@export var is_player = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_is_player():
	return is_player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !is_player:
		rotate(Vector3.UP,.01)
	pass
