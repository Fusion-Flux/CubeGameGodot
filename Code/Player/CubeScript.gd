extends Node3D

var EaseApi = preload("res://Code/APIs/EaseApi.gd")

var accum_time = 0.0
var durration = 1

@export var stored_scale = .95
@export var fake_scale = .95
var target_scale = .95

@onready var reference_object = get_node_or_null("../../../../../../RigidBody3D/Customization/Cores")

@onready var customization_ref = $".."
var player = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#stored_scale = 1.0
	stored_scale = .95
	fake_scale = .95
	target_scale = .95
	accum_time = 0.0
	player = customization_ref.get_is_player()
	self.visible = SaveLoad.SaveFileData.core_shown
	pass # Replace with function body.

func set_mesh_scale(new_scale: float) -> void:  # Public method
	new_scale = new_scale/100.0
	if stored_scale - new_scale != fake_scale:
		target_scale = stored_scale - new_scale
		accum_time = 0
	pass

func _process(_delta: float) -> void:
	accum_time += _delta
	if accum_time >= durration:
		pass
		fake_scale =lerpf(fake_scale,target_scale,1)
		self.scale = Vector3(fake_scale,fake_scale,fake_scale)
		#accum_time = 0
	else:
		fake_scale = lerpf(fake_scale,target_scale,accum_time/durration)
		self.scale = Vector3(fake_scale,fake_scale,fake_scale)
		
	if reference_object != null && !player:
		reference_object.visible = self.visible
		


func _on_check_button_toggled(toggled_on: bool) -> void:
	self.visible = toggled_on
	pass # Replace with function body.
