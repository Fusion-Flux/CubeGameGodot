extends Camera3D

var stored_fov = 75.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stored_fov = self.fov
	pass # Replace with function body.

func set_camera_fov(fov: float) -> void:  # Public method
	self.fov = stored_fov + fov
	pass
