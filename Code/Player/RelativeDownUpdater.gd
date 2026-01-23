extends Node

var current_down = Vector3.DOWN

var target_down = Vector3.DOWN

var storedQuaternion = Quaternion()

var accum_time = 0.0

var durration = .25
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#storedQuaternion = self.quaternion
	pass # Replace with function body.

func set_target_down(direction: Vector3) -> void:  # Public method
	target_down = direction;
	pass
	
func reset_camera_down(correctDown: Vector3) -> void:
	self.quaternion = Quaternion(Vector3.DOWN,correctDown)
	storedQuaternion = self.quaternion
	current_down = correctDown
	target_down = correctDown
	pass
func easeInOutQuad(x: float) -> float :
	return 2 * x * x if  x < 0.5  else 1 - (-2 * x + 2)**2 / 2


func easeInBack(x: float) -> float :
	const c1 = 1.70158;
	const c3 = c1 + 1;

	return c3 * x * x * x - c1 * x * x;


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
			
			self.quaternion = storedQuaternion.slerp(storedQuaternion*Quaternion(current_down,target_down), easeInBack(accum_time/durration) )
			accum_time += _delta
	
	pass
