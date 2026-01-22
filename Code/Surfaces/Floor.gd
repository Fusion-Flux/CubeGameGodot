extends Area3D

@export var collision_direction = Vector3.DOWN
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_collision_direction() -> Vector3:  # Public method
	return collision_direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
