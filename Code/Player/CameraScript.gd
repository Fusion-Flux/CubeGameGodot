extends Camera3D

var stored_fov = 100.0
var target_fov = 100.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stored_fov = self.fov
	pass # Replace with function body.

func set_camera_fov(fov: float) -> void:  # Public method
	target_fov = stored_fov + fov/2
	pass
