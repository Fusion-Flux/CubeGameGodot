@icon("res://Assets/Textures/UI/EditorIcons/default.png")

extends Node3D

@onready var collision = $StaticBody3D
@onready var validflooring = $StaticBody3D/CollisionShape3D/ValidFlooring
@onready var defaultflooring = $StaticBody3D/CollisionShape3D/DefaultFlooring

@export var valid_floors: Array[Vector3]

func _ready() -> void:
	for r in valid_floors:
		match r:
			Vector3.DOWN:
				collision.set_collision_mask_value(9,true)
				validflooring.set_layer_mask_value(9,true)
				defaultflooring.set_layer_mask_value(9,false)
			Vector3.UP:
				collision.set_collision_mask_value(10,true)
				validflooring.set_layer_mask_value(10,true)
				defaultflooring.set_layer_mask_value(10,false)
			Vector3.LEFT:
				collision.set_collision_mask_value(11,true)
				validflooring.set_layer_mask_value(11,true)
				defaultflooring.set_layer_mask_value(11,false)
			Vector3.RIGHT:
				collision.set_collision_mask_value(12,true)
				validflooring.set_layer_mask_value(12,true)
				defaultflooring.set_layer_mask_value(12,false)
			Vector3.FORWARD:
				collision.set_collision_mask_value(13,true)
				validflooring.set_layer_mask_value(13,true)
				defaultflooring.set_layer_mask_value(13,false)
			Vector3.BACK:
				collision.set_collision_mask_value(14,true)
				validflooring.set_layer_mask_value(14,true)
				defaultflooring.set_layer_mask_value(14,false)
			_:
				collision.set_collision_mask_value(15,true)
				validflooring.set_layer_mask_value(15,true)
				defaultflooring.set_layer_mask_value(15,false)
	pass
