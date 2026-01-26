extends SpringArm3D


@onready var camera = $Camera3D
var stored_spring_length = self.spring_length
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func add_object(object: RID) -> void:  # Public method
	self.add_excluded_object(object)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.spring_length = stored_spring_length - (camera.fov - 100)/25
	pass
