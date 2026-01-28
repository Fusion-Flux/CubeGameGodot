extends Camera3D

var EaseApi = preload("res://Code/APIs/EaseApi.gd")

var accum_time = 0.0
var durration = 1

var stored_fov = 100.0
var target_fov = 100.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stored_fov = self.fov
	pass # Replace with function body.

func set_camera_fov(new_fov: float) -> void:  # Public method
	if stored_fov + new_fov != self.fov:
		target_fov = stored_fov + new_fov
		accum_time = 0
	pass

func _process(_delta: float) -> void:
	if accum_time >= durration:
		self.fov =lerpf(self.fov,target_fov,1)
		accum_time = 0
	else:
		accum_time += _delta
		self.fov = lerpf(self.fov,target_fov,accum_time/durration)
