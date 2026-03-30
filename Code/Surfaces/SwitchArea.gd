extends Node

@onready var switchNode = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func switchActivated():
	switchNode.turnOn()
