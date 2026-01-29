extends Control

var skipframe = false;

@onready var AppearenceMenu = $"Appearence Menu"
@onready var MainMenu = $"Main Menu"
@onready var Rainbow = $"../RigidBody3D/Customization/Outlines/Rainbow"
@onready var Trans = $"../RigidBody3D/Customization/Outlines/Trans"
@onready var Bi = $"../RigidBody3D/Customization/Outlines/Bi"
@onready var Space = $"../RigidBody3D/Customization/Outlines/Space"
@onready var Davekat = $"../RigidBody3D/Customization/Outlines/Davekat"

@onready var BlackCore = $"../RigidBody3D/Customization/Cores/BlackCore"
@onready var EarthCore =$"../RigidBody3D/Customization/Cores/EarthCore"
@onready var HeartCore =$"../RigidBody3D/Customization/Cores/HeartCore"

@onready var ShownOutline = Rainbow
@onready var ShownCore = BlackCore
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	pass # Replace with function body.

func _showma() -> void:
	show()
	skipframe = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause",false) && !skipframe && self.visible:
		hide()
		MainMenu.show()
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

func _on_return_from_appearence_pressed() -> void:
	AppearenceMenu.hide()
	MainMenu.show()
	pass # Replace with function body.

func _on_core_list_item_selected(index: int) -> void:
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


func _on_back_to_game_pressed() -> void:
	hide()
	MainMenu.show()
	AppearenceMenu.hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.
