extends Control


@export var nextlevelfile = "res://Levels/Core/TitleScreen.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()
	pass # Replace with function body.

func _process(_delta: float) -> void:
	if visible:
		if Input.is_action_just_pressed("jump", false):
			get_tree().change_scene_to_file(nextlevelfile)
			pass
		pass


func _on_next_level_pressed() -> void:
	get_tree().change_scene_to_file(nextlevelfile)
	pass # Replace with function body.
