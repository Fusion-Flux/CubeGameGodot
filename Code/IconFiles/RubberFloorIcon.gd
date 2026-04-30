@icon("res://Assets/Textures/UI/EditorIcons/rubber.png")

extends Node3D

@onready var collision = $StaticBody3D

@export var valid_floors: Array[Vector3]

func _ready() -> void:
	for r in valid_floors:
		match r:
			Vector3.DOWN:
				collision.set_collision_mask_value(9,true)
			Vector3.UP:
				collision.set_collision_mask_value(10,true)
			Vector3.LEFT:
				collision.set_collision_mask_value(11,true)
			Vector3.RIGHT:
				collision.set_collision_mask_value(12,true)
			Vector3.FORWARD:
				collision.set_collision_mask_value(13,true)
			Vector3.BACK:
				collision.set_collision_mask_value(14,true)
			_:
				collision.set_collision_mask_value(15,true)
	pass
