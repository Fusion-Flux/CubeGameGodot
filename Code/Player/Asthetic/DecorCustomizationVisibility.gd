extends Node3D

@onready var reference_object = get_node_or_null("../../../../../../../RigidBody3D/Customization/Decor/" + name)

@onready var customization_ref = $"../.."
var player = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = customization_ref.get_is_player()
	visibility_changed.connect(_on_visibility_changed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_visibility_changed() -> void:
	if reference_object != null && !player:
		reference_object.visible = self.visible
	pass # Replace with function body.
