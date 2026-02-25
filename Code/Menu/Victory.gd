extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()
	pass # Replace with function body.

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("jump", false):
		print("next level transition")
		pass
	pass
