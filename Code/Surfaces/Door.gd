extends Node

@export var Switches: Array[Node3D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var switchesActive = 0
	for switch in Switches:
		if switch.checkOn():
			switchesActive += 1
	if switchesActive == Switches.size():
		self.queue_free()
		print("krillion")
	pass
