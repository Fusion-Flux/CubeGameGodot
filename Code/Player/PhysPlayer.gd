extends RigidBody3D


@export var torque_strength = 0.5  # Adjust as needed
@export var force_strength = 1 
@export var max_angular_speed = 20.0  # Radians per second
@export var jump_strength = 2.0
@export var slam_impulse = 50.0
@export var dash_impulse = 15.0
# default gravity value (make me maluable! so we can have silly gravity levels and gravity changes)
@export var gravity = 9.8 

@export var jumps = 2
@export var dashes = 3
@export var slams = 1

@export var masklayer = 9

var can_move = true

var dash_regen_timer = 0.0

var ground_touch_timer = 1

@export var refill_meter = ProgressBar
@export var dashes_bar = ProgressBar
@export var jumps_bar = ProgressBar
@export var slams_bar = ProgressBar

# this should be defineable on a per level basis and easily accessed by gravity changers
# additionally this will be what tells us what the cameras relative down is
@export var gravity_direction = Vector3.DOWN

@export var relative_down_node = Node3D

@export var camera_node = Node3D

@export var camera_controller = Camera3D

@export var checkpoint = Area3D

@export var spring_arm = SpringArm3D

@export var inner_cube = MeshInstance3D

var paused = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera_node.global_position = self.global_position
	spring_arm.add_object(self)
	
	torque_strength = torque_strength * self.mass
	force_strength = force_strength * self.mass
	jump_strength = jump_strength * self.mass
	slam_impulse = slam_impulse * self.mass
	dash_impulse = dash_impulse * self.mass
	gravity = gravity * self.mass

	pass # Replace with function body.

func get_gravity_direction() -> Vector3:  # Public method
	return gravity_direction

func set_gravity_direction(direction: Vector3) -> void:  # Public method
	direction = direction.normalized()
	relative_down_node.set_target_down(direction)
	gravity_direction = direction
	match direction:
		Vector3.DOWN:
			masklayer = 9 # -Y 
		Vector3.UP:
			masklayer = 10 # Y 
		Vector3.LEFT:
			masklayer = 11 # -X 
		Vector3.RIGHT:
			masklayer = 12 # X 
		Vector3.FORWARD:
			masklayer = 13 # -Z 
		Vector3.BACK:
			masklayer = 14 # Z
		_:
			masklayer = 15 # Undefined Direction
	pass
	
	
func movement_process(obtained_quat: Quaternion, grav_quat: Quaternion, modified_force_strength: float) -> void:
	var torque_movement = Vector3(0,0,0)
	var force_movement = Vector3(0,0,0)
	
	if Input.is_action_pressed("rotate_left"):
		torque_movement += Vector3.BACK
		force_movement += Vector3.LEFT
	if Input.is_action_pressed("rotate_right"):
		torque_movement += Vector3.FORWARD
		force_movement += Vector3.RIGHT
	if Input.is_action_pressed("rotate_forward"):
		torque_movement += Vector3.LEFT
		force_movement += Vector3.FORWARD
	if Input.is_action_pressed("rotate_back"):
		torque_movement += Vector3.RIGHT
		force_movement += Vector3.BACK
		
	apply_torque_impulse(grav_quat * obtained_quat * torque_movement.normalized() * torque_strength)
	apply_central_force(grav_quat * obtained_quat * force_movement.normalized() * modified_force_strength)
	pass

func dash_process(obtained_quat_with_vert: Quaternion, grav_quat:Quaternion) -> void:
	if Input.is_action_just_pressed("dash",false) && dashes > 0 && can_move:
		var dash_impulse_direction = Vector3(0,0,0)
		
		if Input.is_action_pressed("rotate_forward"):
			dash_impulse_direction += Vector3.FORWARD
		if Input.is_action_pressed("rotate_left"):
			dash_impulse_direction += Vector3.LEFT
		if Input.is_action_pressed("rotate_right"):
			dash_impulse_direction += Vector3.RIGHT
		if Input.is_action_pressed("rotate_back"):
			dash_impulse_direction += Vector3.BACK
		if !Input.is_action_pressed("rotate_forward") && !Input.is_action_pressed("rotate_back") && !Input.is_action_pressed("rotate_right") && !Input.is_action_pressed("rotate_left"):
			dash_impulse_direction += Vector3.FORWARD
		
		apply_impulse((grav_quat *(obtained_quat_with_vert *dash_impulse_direction.normalized()))*dash_impulse)
		
		dashes -= 1
		ground_touch_timer += .25
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	apply_central_force(gravity_direction*gravity)
	
	var obtained_quat = camera_node.get_quat_no_vert()
	var obtained_quat_with_vert = camera_node.quaternion
	var grav_quat = relative_down_node.quaternion
	
	camera_controller.set_camera_fov(self.linear_velocity.length())
	
		
	var should_regen_tick = (ground_touch_timer > 0 || (self.angular_velocity.length() <= 0.00009 && self.linear_velocity.length() <= 0.00009))
	
	if dashes < 3 && should_regen_tick:
		dash_regen_timer += delta
	
	if dash_regen_timer >= 1.5 && dashes < 3 && should_regen_tick:
		dashes += 1
		if dashes != 3:
			dash_regen_timer -= 1.5
		else:
			dash_regen_timer = 0
	if should_regen_tick:
		ground_touch_timer -= delta
	
	# do the movements
	#cancel force application when movement is disabled
	#standard WASD movement
	if can_move:
		movement_process(obtained_quat,grav_quat,force_strength)
	else:
		movement_process(obtained_quat,grav_quat,0)
	
	#dashing check
	dash_process(obtained_quat_with_vert,grav_quat)
	
	refill_meter.set_percentage((dash_regen_timer + dashes*1.5)/ (3*1.5) * 100)
	dashes_bar.set_percentage((dashes/3.0)* 100.0)
	
	
	if Input.is_action_just_pressed("jump",false) && jumps > 0 && can_move:
		if (self.linear_velocity*gravity_direction.abs()).normalized() == gravity_direction:
			self.linear_velocity += self.linear_velocity*(gravity_direction.abs()*-1)
			pass
		apply_impulse((grav_quat *(obtained_quat *Vector3.UP))*jump_strength)
		jumps -= 1
		
	jumps_bar.set_percentage((jumps/2.0)*100.0)
	
	#slam doesnt need a seperate method due to its sheer simplicity
	if Input.is_action_just_pressed("slam",false) && slams > 0 && can_move: 
		if (self.linear_velocity*gravity_direction.abs()).normalized() == gravity_direction*-1:
			self.linear_velocity += self.linear_velocity*(gravity_direction.abs()*-1)
			pass
		apply_impulse((grav_quat *(Vector3.DOWN)*slam_impulse))
		slams -= 1
		
	slams_bar.set_percentage(slams*100)
	
	camera_controller.set_camera_fov(self.linear_velocity.length())
	inner_cube.set_mesh_scale(self.linear_velocity.length())
	pass
	
func _process(_delta: float) -> void:
	if Input.is_action_pressed("pause") && !paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		paused = true
	if Input.is_action_pressed("click") && paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		paused = false
	pass
	
func _on_cube_hitbox_area_entered(area: Area3D) -> void:
	DebugDraw2D.set_text("Area Collision Layer", area.collision_layer)
	if area.get_collision_layer_value(2):
		set_gravity_direction(area.get_stored_gravity_direction())
		pass
	if area.get_collision_layer_value(3):
		set_gravity_direction(checkpoint.get_checkpoint_gravity_direction())
		relative_down_node.reset_camera_down(checkpoint.get_checkpoint_gravity_direction())
		self.position = checkpoint.position + checkpoint.get_respawn_offset()
		self.linear_velocity = Vector3()
		jumps = 2
		slams = 1
		dashes = 3
		can_move = false
		pass
	if area.get_collision_layer_value(4):
		checkpoint = area
		pass
	pass # Replace with function body.


func _on_cube_collision_detector_body_entered(body: Node3D) -> void:
	#print(body)
	
	if body is StaticBody3D:
		var collision_shape = body as StaticBody3D
		if collision_shape.get_collision_mask_value(masklayer):
			jumps = 2
			slams = 1
			can_move = true;
			ground_touch_timer = 1
			pass
		pass
	pass # Replace with function body.
