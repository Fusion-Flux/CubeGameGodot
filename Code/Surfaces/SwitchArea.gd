extends Node

@onready var switchNode = $".."
@onready var meshoff = $MeshInstance3D
@onready var meshon = $MeshInstance3D2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func switchActivated():
	switchNode.turnOn()
	meshoff.visible = false
	meshon.visible = true
