extends Node3D

@onready var reference_object = get_node_or_null("../../../../../../RigidBody3D/Customization/Cores")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = SaveLoad.SaveFileData.core_shown
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if reference_object != null:
		reference_object.visible = self.visible
	pass


func _on_check_button_toggled(toggled_on: bool) -> void:
	self.visible = toggled_on
	pass # Replace with function body.
