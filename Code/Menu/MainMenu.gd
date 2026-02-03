extends Control

var skipframe = false;

@onready var AppearenceMenu = $"Appearence Menu"
@onready var MainMenu = $"Main Menu"
@onready var LevelSelect = $"Level Selection"
@onready var Rainbow = $"Appearence Menu/SubViewportContainer/SubViewport/Customization/Outlines/Rainbow"
@onready var Trans = $"Appearence Menu/SubViewportContainer/SubViewport/Customization/Outlines/Trans"
@onready var Bi = $"Appearence Menu/SubViewportContainer/SubViewport/Customization/Outlines/Bi"
@onready var Space = $"Appearence Menu/SubViewportContainer/SubViewport/Customization/Outlines/Space"
@onready var Davekat = $"Appearence Menu/SubViewportContainer/SubViewport/Customization/Outlines/Davekat"

@onready var BlackCore = $"Appearence Menu/SubViewportContainer/SubViewport/Customization/Cores/BlackCore"
@onready var EarthCore =$"Appearence Menu/SubViewportContainer/SubViewport/Customization/Cores/EarthCore"
@onready var HeartCore =$"Appearence Menu/SubViewportContainer/SubViewport/Customization/Cores/HeartCore"

@onready var ShownOutline = Rainbow
@onready var ShownCore = BlackCore

var save_path = "res://SavData/apperencesave.json"

var outline_index = 0
var core_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_data()
	#print(core_index)
	#print(outline_index)
	_on_core_list_item_selected(core_index)
	_on_outline_list_item_selected(outline_index)
	pass # Replace with function body.

func _showma() -> void:
	show()
	skipframe = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

var PlayerData: Dictionary = {
	"levels_unlocked": 1,
	"outline": outline_index,
	"core": core_index
}
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

func _on_core_list_item_selected(index: int) -> void:
	core_index = index
	save()
	match index:
		0:
			ShownCore.hide()
			ShownCore = BlackCore
			BlackCore.show()
		1:
			ShownCore.hide()
			ShownCore = HeartCore
			HeartCore.show()
		2:
			ShownCore.hide()
			ShownCore = EarthCore
			EarthCore.show()
		_:
			pass
	pass # Replace with function body.

func _on_outline_list_item_selected(index: int) -> void:
	outline_index = index
	save()
	match index:
		0:
			ShownOutline.hide()
			ShownOutline = Rainbow
			Rainbow.show()
		1:
			ShownOutline.hide()
			ShownOutline = Bi
			Bi.show()
		2:
			ShownOutline.hide()
			ShownOutline = Trans
			Trans.show()
		3:
			ShownOutline.hide()
			ShownOutline = Davekat
			Davekat.show()
		4:
			ShownOutline.hide()
			ShownOutline = Space
			Space.show()
		_:
			pass
	pass # Replace with function body.

func save():
	PlayerData.outline = outline_index
	PlayerData.core = core_index
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	print(PlayerData)
	file.store_var(PlayerData.duplicate())
	file.close()

func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var data = file.get_var()
		print(data)
		file.close()
		
		var save_data = data.duplicate()
		PlayerData.outline = save_data.outline
		PlayerData.core = save_data.core
		outline_index = PlayerData.outline
		core_index = PlayerData.core

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
			get_tree().change_scene_to_file("res://Levels/Tutorial.tscn")
			pass
		_:
			pass
	pass # Replace with function body.


func _on_level_select_pressed() -> void:
	MainMenu.hide()
	LevelSelect.show()
	pass # Replace with function body.
