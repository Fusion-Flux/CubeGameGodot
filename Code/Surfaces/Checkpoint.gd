extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
@export var stored_gravity_direction = Vector3.DOWN
@export var respawn_offset = Vector3.UP
	
func get_checkpoint_gravity_direction() -> Vector3:  # Public method
	return stored_gravity_direction

func get_respawn_offset() -> Vector3:  # Public method
	return respawn_offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
