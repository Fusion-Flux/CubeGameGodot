extends Node

var current_down = Vector3.DOWN

var target_down = Vector3.DOWN

var storedQuaternion = Quaternion()

var accum_time = 0.0

var durration = .5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#storedQuaternion = self.quaternion
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
		
		if accum_time >= durration:
			self.quaternion = storedQuaternion*Quaternion(current_down,target_down)
			storedQuaternion = self.quaternion
			current_down = target_down
			accum_time = 0.0
		else:
			print(accum_time)
			self.quaternion = storedQuaternion.slerp(storedQuaternion*Quaternion(current_down,target_down), accum_time/durration )
			accum_time += _delta
		#self.quaternion *= Quaternion(current_down,target_down)
		#current_down = target_down
		
		
	
	pass
