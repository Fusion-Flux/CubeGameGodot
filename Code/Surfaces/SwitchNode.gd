@icon("res://Assets/Textures/UI/EditorIcons/switchicon.png")

extends Node

var isOn = false
@export var door = Node3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func turnOn():
	isOn = true
	door.switchTrigger()

func checkOn():
	return isOn
