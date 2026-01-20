extends Node

var current_down = Vector3.DOWN

var target_down = Vector3.DOWN

const TOLERANCE = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_target_down(direction: Vector3) -> void:  # Public method
	target_down = direction;
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var axis = current_down.cross(target_down)
	if axis.length() == 0:
		return # If vectors are collinear, no rotation needed
	
	axis = axis.normalized()
	var angle = acos(current_down.dot(target_down))
	print()
	var quaternion = Quaternion(axis, angle)
	self.quaternion = quaternion
	current_down = target_down
	pass
