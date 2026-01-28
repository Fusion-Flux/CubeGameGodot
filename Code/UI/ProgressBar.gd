extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.

func set_percentage(percentage: float) -> void:  # Public method
	self.set_value_no_signal(percentage)
	pass
