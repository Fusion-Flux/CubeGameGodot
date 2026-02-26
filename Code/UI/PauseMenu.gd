extends Control

var skipframe = false;

@onready var AppearenceMenu = $"Appearence Menu"
@onready var MainMenu = $"MainPauseMenu"

var outline_index = 0
var core_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	pass # Replace with function body.

func _showma() -> void:
	show()
	skipframe = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause",false) && !skipframe && self.visible:
		hide()
		#MainMenu.show()
		AppearenceMenu.hide()
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		pass
	if skipframe:
		skipframe = false
	pass

#Outlines
func _on_button_pressed() -> void:
	MainMenu.hide()
	AppearenceMenu.show()
	pass # Replace with function body.


func _on_back_to_game_pressed() -> void:
	hide()
	MainMenu.show()
	AppearenceMenu.hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.


func _on_return_to_title_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Levels/Core/TitleScreen.tscn")
	pass # Replace with function body.

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
	pass # Replace with function body.
