extends RigidBody3D


@export var torque_strength = 0.5  # Adjust as needed
@export var force_strength = 1 
@export var max_angular_speed = 20.0  # Radians per second
@export var jump_strength = 2.0
@export var slam_impulse = 50.0
@export var dash_impulse = 25.0
# default gravity value (make me maluable! so we can have silly gravity levels and gravity changes)
@export var gravity = 9.8 

# this should be defineable on a per level basis and easily accessed by gravity changers
# additionally this will be what tells us what the cameras relative down is
@export var gravity_direction = Vector3.DOWN

@export var relative_down_node = Node3D

@export var camera_node = Node3D

@export var camera_controller = Camera3D

@export var checkpoint = Area3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera_node.global_position = self.global_position
	pass # Replace with function body.

func get_gravity_direction() -> Vector3:  # Public method
	return gravity_direction

func set_gravity_direction(direction: Vector3) -> void:  # Public method
	relative_down_node.set_target_down(direction)
	gravity_direction = direction;
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var isOverspeed = angular_velocity.length() < max_angular_speed;
	
	apply_central_force(gravity_direction*gravity)
	var obtained_quat = camera_node.get_quat_no_vert()
	var obtained_quat_with_vert = camera_node.quaternion
	var grav_quat = relative_down_node.quaternion
	camera_controller.set_camera_fov(self.linear_velocity.length())
	if Input.is_action_pressed("rotate_left"):
		apply_torque_impulse(grav_quat * obtained_quat * Vector3.BACK * torque_strength)
		apply_central_force(grav_quat * obtained_quat * Vector3.LEFT * force_strength)
	if Input.is_action_pressed("rotate_right"):
		apply_torque_impulse(grav_quat * obtained_quat * Vector3.FORWARD * torque_strength)
		apply_central_force(grav_quat * obtained_quat * Vector3.RIGHT * force_strength)
	if Input.is_action_pressed("rotate_forward"):
		apply_torque_impulse(grav_quat * obtained_quat * Vector3.LEFT * torque_strength)
		apply_central_force(grav_quat * obtained_quat * Vector3.FORWARD * force_strength)
	if Input.is_action_pressed("rotate_back"):
		apply_torque_impulse(grav_quat * obtained_quat * Vector3.RIGHT * torque_strength)
		apply_central_force(grav_quat * obtained_quat * Vector3.BACK * force_strength)
		
	if Input.is_action_pressed("jump"):
		apply_impulse((grav_quat *(obtained_quat *Vector3.UP))*jump_strength)
	if Input.is_action_pressed("dash"):
		apply_impulse((grav_quat *(obtained_quat_with_vert *Vector3.FORWARD)))
	if Input.is_action_pressed("slam"):
		apply_impulse((grav_quat *(obtained_quat *Vector3.DOWN)))
	
	pass


func _on_cube_hitbox_area_entered(area: Area3D) -> void:
	if area.has_method("get_stored_gravity_direction"):
		set_gravity_direction(area.call("get_stored_gravity_direction"))
		pass
	if area.collision_layer == 5:
		relative_down_node.reset_camera_down(checkpoint.get_checkpoint_gravity_direction())
		gravity_direction = checkpoint.get_checkpoint_gravity_direction()
		self.position = checkpoint.position + checkpoint.get_respawn_offset()
		self.linear_velocity = Vector3()
		pass
	pass # Replace with function body.
