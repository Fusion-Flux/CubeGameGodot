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
	pass # Replace with function body.

func _showma() -> void:
	show()
	skipframe = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause",false) && !skipframe:
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


func _enable_davekat() -> void:
	ShownOutline.hide()
	ShownOutline = Davekat
	Davekat.show()
	pass # Replace with function body.


func _on_rainbow_pressed() -> void:
	ShownOutline.hide()
	ShownOutline = Rainbow
	Rainbow.show()
	pass # Replace with function body.


func _on_bi_pressed() -> void:
	ShownOutline.hide()
	ShownOutline = Bi
	Bi.show()
	pass # Replace with function body.


func _on_trans_pressed() -> void:
	ShownOutline.hide()
	ShownOutline = Trans
	Trans.show()
	pass # Replace with function body.


func _on_space_pressed() -> void:
	ShownOutline.hide()
	ShownOutline = Space
	Space.show()
	pass # Replace with function body.



#Cores
func _on_black_pressed() -> void:
	ShownCore.hide()
	ShownCore = BlackCore
	BlackCore.show()
	pass # Replace with function body.


func _on_heart_pressed() -> void:
	ShownCore.hide()
	ShownCore = HeartCore
	HeartCore.show()
	pass # Replace with function body.


func _on_earth_pressed() -> void:
	ShownCore.hide()
	ShownCore = EarthCore
	EarthCore.show()
	pass # Replace with function body.


func _on_return_from_appearence_pressed() -> void:
	AppearenceMenu.hide()
	MainMenu.show()
	pass # Replace with function body.
