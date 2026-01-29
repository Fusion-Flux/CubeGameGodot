extends Node3D

@onready var reference_object = $"../../../../../../../RigidBody3D/Customization/Outlines/Bi"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.visible = reference_object.visible
	pass
