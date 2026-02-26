extends Node3D

@onready var reference_object = get_node_or_null("../../../../../../../RigidBody3D/Customization/Cores/" + name)

@onready var customization_ref = $"../.."
var player = false

func _ready() -> void:
	player = customization_ref.get_is_player()
	visibility_changed.connect(_on_visibility_changed)


func _on_visibility_changed() -> void:
	if reference_object != null && !player:
		reference_object.visible = self.visible
