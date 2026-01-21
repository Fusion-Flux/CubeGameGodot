extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.

@export var target: Node3D

@export var mouse_sensitivity: float = 0.002
var rotation_x: float = 0
var rotation_y: float = 0

var no_vertical_quat = Quaternion(Vector3.UP, rotation_y)

func _input(event):
	if event is InputEventMouseMotion:
		rotation_y -= event.relative.x * mouse_sensitivity
		rotation_x -= event.relative.y * mouse_sensitivity
		rotation_x = clamp(rotation_x, -PI/2, PI/2)
	pass

func get_quat_no_vert() -> Quaternion:  # Public method
	return no_vertical_quat

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	self.global_position = target.position;
	
	var rot_y = Quaternion(Vector3.UP, rotation_y)
	var rot_x = Quaternion(Vector3.RIGHT, rotation_x)
	no_vertical_quat = rot_y

	# Combine rotations
	var final_rot = rot_y * rot_x
	# Apply to camera
	self.quaternion = final_rot
	pass
