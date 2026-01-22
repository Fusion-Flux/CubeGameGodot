extends Area3D


@export var stored_gravity_direction = Vector3.FORWARD
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_stored_gravity_direction() -> Vector3:  # Public method
	#print(stored_gravity_direction)
	return stored_gravity_direction
