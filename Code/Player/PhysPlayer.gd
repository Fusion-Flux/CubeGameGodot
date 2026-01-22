extends RigidBody3D


@export var torque_strength = 0.5  # Adjust as needed
@export var force_strength = 1 
@export var max_angular_speed = 20.0  # Radians per second
@export var jump_strength = 2.0
@export var slam_impulse = 50.0
@export var dash_impulse = 25.0
# default gravity value (make me maluable! so we can have silly gravity levels and gravity changes)
@export var gravity = 9.8 

@export var jumps = 2
@export var dashes = 3
@export var slams = 1

# this should be defineable on a per level basis and easily accessed by gravity changers
# additionally this will be what tells us what the cameras relative down is
@export var gravity_direction = Vector3.DOWN

@export var relative_down_node = Node3D

@export var camera_node = Node3D

@export var camera_controller = Camera3D

@export var checkpoint = Area3D

var paused = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera_node.global_position = self.global_position
	pass # Replace with function body.

func get_gravity_direction() -> Vector3:  # Public method
	return gravity_direction

func set_gravity_direction(direction: Vector3) -> void:  # Public method
	relative_down_node.set_target_down(direction)
	gravity_direction = direction
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var isOverspeed = angular_velocity.length() < max_angular_speed;
	isOverspeed = true
	apply_central_force(gravity_direction*gravity)
	
	var obtained_quat = camera_node.get_quat_no_vert()
	var obtained_quat_with_vert = camera_node.quaternion
	var grav_quat = relative_down_node.quaternion
	
	camera_controller.set_camera_fov(self.linear_velocity.length())
	
	
	if Input.is_action_pressed("rotate_left") && isOverspeed:
		apply_torque_impulse(grav_quat * obtained_quat * Vector3.BACK * torque_strength)
		apply_central_force(grav_quat * obtained_quat * Vector3.LEFT * force_strength)
	if Input.is_action_pressed("rotate_right")&& isOverspeed:
		apply_torque_impulse(grav_quat * obtained_quat * Vector3.FORWARD * torque_strength)
		apply_central_force(grav_quat * obtained_quat * Vector3.RIGHT * force_strength)
	if Input.is_action_pressed("rotate_forward")&& isOverspeed:
		apply_torque_impulse(grav_quat * obtained_quat * Vector3.LEFT * torque_strength)
		apply_central_force(grav_quat * obtained_quat * Vector3.FORWARD * force_strength)
	if Input.is_action_pressed("rotate_back")&& isOverspeed:
		apply_torque_impulse(grav_quat * obtained_quat * Vector3.RIGHT * torque_strength)
		apply_central_force(grav_quat * obtained_quat * Vector3.BACK * force_strength)
		
	if Input.is_action_just_pressed("jump",false) && jumps > 0:
		apply_impulse((grav_quat *(obtained_quat *Vector3.UP))*jump_strength)
		jumps -= 1
	if Input.is_action_just_pressed("dash",false) && dashes > 0:
		if Input.is_action_pressed("rotate_forward"):
			apply_impulse((grav_quat *(obtained_quat_with_vert *Vector3.FORWARD))*dash_impulse)
		if Input.is_action_pressed("rotate_left"):
			apply_impulse((grav_quat *(obtained_quat_with_vert *Vector3.LEFT))*dash_impulse)
		if Input.is_action_pressed("rotate_right"):
			apply_impulse((grav_quat *(obtained_quat_with_vert *Vector3.RIGHT))*dash_impulse)
		if Input.is_action_pressed("rotate_back"):
			apply_impulse((grav_quat *(obtained_quat_with_vert *Vector3.BACK))*dash_impulse)
		if !Input.is_action_pressed("rotate_forward") && !Input.is_action_pressed("rotate_back") && !Input.is_action_pressed("rotate_right") && !Input.is_action_pressed("rotate_left"):
			apply_impulse((grav_quat *(obtained_quat_with_vert *Vector3.FORWARD))*dash_impulse)
		dashes -= 1
		
	if Input.is_action_just_pressed("slam",false) && slams > 0: 
		apply_impulse((grav_quat *(Vector3.DOWN)*slam_impulse))
		slams -= 1
	pass
	
func _process(_delta: float) -> void:
	if Input.is_action_pressed("pause") && !paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		paused = true
	if Input.is_action_pressed("click") && paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass
	
func _on_cube_hitbox_area_entered(area: Area3D) -> void:
	print(area.collision_layer )
	if area.has_method("get_stored_gravity_direction"):
		set_gravity_direction(area.call("get_stored_gravity_direction"))
		pass
	if area.collision_layer == 4:
		relative_down_node.reset_camera_down(checkpoint.get_checkpoint_gravity_direction())
		gravity_direction = checkpoint.get_checkpoint_gravity_direction()
		self.position = checkpoint.position + checkpoint.get_respawn_offset()
		self.linear_velocity = Vector3()
		pass
	if area.collision_layer == 8:
		checkpoint = area
		pass
	if area.collision_layer==16:
		if area.get_collision_direction() == self.get_gravity_direction():
			jumps = 2
			slams = 1
			dashes = 3
		pass
	pass # Replace with function body.


func _on_cube_collision_detector_body_entered(body: Node3D) -> void:
	if body is StaticBody3D:
		var collision_shape = body as StaticBody3D
		if collision_shape.collision_mask == 256:
			jumps = 2
			slams = 1
			dashes = 3
			pass
		pass
	pass # Replace with function body.
