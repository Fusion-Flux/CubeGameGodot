extends Control

var skipframe = false;

@onready var AppearenceMenu = $"Appearence Menu"
@onready var MainMenu = $"Main Menu"
@onready var LevelSelect = $"Level Selection"

@onready var titlecard = $"Main Menu/TITLE"

var save_path = "res://SavData/apperencesave.json"

var outline_index = 0
var core_index = 0

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	if randi_range(1, 10000) == 900:
		titlecard.text = "[font=res://Assets/Fonts/papyrus.ttf]CUBE GAME"
	pass # Replace with function body.

func _showma() -> void:
	show()
	skipframe = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

#Outlines
func _on_button_pressed() -> void:
	MainMenu.hide()
	AppearenceMenu.show()
	pass # Replace with function body.

func _on_return_from_appearence_pressed() -> void:
	AppearenceMenu.hide()
	LevelSelect.hide()
	MainMenu.show()
	pass # Replace with function body.


func _on_back_to_game_pressed() -> void:
	hide()
	MainMenu.show()
	AppearenceMenu.hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.


func _on_level_select_item_selected(index: int) -> void:
	match index:
		0:
			get_tree().change_scene_to_file("res://Levels/Core/Tutorial.tscn")
			pass
		1:
			get_tree().change_scene_to_file("res://Levels/Core/Level2.tscn")
			pass
		2:
			get_tree().change_scene_to_file("res://Levels/Core/MindTheGap.tscn")
			pass
		3:
			get_tree().change_scene_to_file("res://Levels/Core/FlippedOnYourHead.tscn")
			pass
		_:
			pass
	pass # Replace with function body.


func _on_level_select_pressed() -> void:
	MainMenu.hide()
	LevelSelect.show()
	pass # Replace with function body.
