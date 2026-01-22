extends Node

var current_down = Vector3.DOWN

var target_down = Vector3.DOWN

const TOLERANCE = 0.1

var testvar1 = Quaternion()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	testvar1 = self.quaternion
	pass # Replace with function body.

func set_target_down(direction: Vector3) -> void:  # Public method
	target_down = direction;
	pass
	
func reset_camera_down(correctDown: Vector3) -> void:
	self.quaternion = Quaternion(Vector3.DOWN,correctDown)
	current_down = correctDown
	target_down = correctDown
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if current_down != target_down:
		var t = 5.0 * _delta
		self.quaternion = self.quaternion.slerp(testvar1 * Quaternion(current_down,target_down),t)
		if self.quaternion == Quaternion(current_down,target_down):
			current_down = target_down
			testvar1 = self.quaternion
		#self.quaternion *= Quaternion(current_down,target_down)
		#current_down = target_down
	pass
