extends RigidBody3D


@export var torque_strength = 0.5  # Adjust as needed
@export var force_strength = 0.25
@export var max_angular_speed = 20.0  # Radians per second
@export var jump_strength = 2.0
@export var slam_impulse = 50.0
@export var dash_impulse = 15.0
# default gravity value (make me maluable! so we can have silly gravity levels and gravity changes)
@export var gravity = 9.8 

@export var max_jumps = 1.0
@export var jumps = max_jumps
@export var max_dashes = 1.0
var dashes = max_dashes
@export var slams = 1

@export var masklayer = 9

var start_countdown = 3

var can_move = false

var has_gravity = false

var dash_regen_timer = 0.0

var ground_touch_timer = 1

@export var refill_meter = ProgressBar
@export var dashes_bar = ProgressBar
@export var jumps_bar = ProgressBar
@export var slams_bar = ProgressBar

@onready var TimerBox = $"../PlayerUI/Control/RichTextLabel"
@onready var TimerBackgroundBox = $"../PlayerUI/Control/RichTextLabel2"

@onready var VictoryTimerBox = $"../Victory/Panel/Victory Timer"
@onready var VictoryTimerBackgroundBox = $"../Victory/Panel/Victory Timer2"

@onready var VictoryScreen = $"../Victory"

@onready var PlayerUI = $"../PlayerUI"

@onready var SceneRoot = $"../../.."

@onready var CountDownNode = $"../PlayerUI/Control/CountdownNumbersNode"

@onready var CountdownNumbersText = $"../PlayerUI/Control/CountdownNumbersNode/CountdownNumbers"

@onready var LevelNameText = $"../Victory/Panel2/LevelName"

var level_time = 0.0

# this should be defineable on a per level basis and easily accessed by gravity changers
# additionally this will be what tells us what the cameras relative down is
@export var gravity_direction = Vector3.DOWN

@export var relative_down_node = Node3D

@export var camera_node = Node3D

@export var camera_controller = Camera3D

@export var checkpoint = Area3D

@onready var glooby = $"../RelativeDown/Camera/SpringArm3D/Camera3D"

@export var spring_arm = SpringArm3D

@export var inner_cube = Node3D

@onready var pause_menu = $"../PauseMenu"

@export var t_rank_time = 0

@export var s_rank_time = 0

@export var a_rank_time = 0

@export var b_rank_time = 0

@export var c_rank_time = 0

@export var d_rank_time = 0


@onready var level_rank = $"../Victory/Rank Box/Rank"

var has_won = false

var skipframe = false

var run_timer = false

var begin_countdown = false

var br8k_countdown = false

var win_target: Area3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera_node.global_position = self.global_position
	spring_arm.add_object(self)
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	torque_strength = torque_strength * self.mass
	force_strength = force_strength * self.mass
	jump_strength = jump_strength * self.mass
	slam_impulse = slam_impulse * self.mass
	dash_impulse = dash_impulse * self.mass
	gravity = gravity * self.mass
	set_gravity_direction(gravity_direction)
	max_dashes = SaveLoad.SaveFileData.saved_max_dashes
	max_jumps = SaveLoad.SaveFileData.saved_max_jumps
	dashes = max_dashes
	jumps = max_jumps
	pass # Replace with function body.

func get_gravity_direction() -> Vector3:  # Public method
	return gravity_direction

func set_gravity_direction(direction: Vector3) -> void:  # Public method
	direction = direction.normalized()
	relative_down_node.set_target_down(direction)
	gravity_direction = direction
	glooby.set_cull_mask_value(masklayer,false)
	match direction:
		Vector3.DOWN:
			masklayer = 9 # -Y 
			glooby.set_cull_mask_value(9,true)
		Vector3.UP:
			masklayer = 10 # Y 
			glooby.set_cull_mask_value(10,true)
		Vector3.LEFT:
			masklayer = 11 # -X 
			glooby.set_cull_mask_value(11,true)
		Vector3.RIGHT:
			masklayer = 12 # X 
			glooby.set_cull_mask_value(12,true)
		Vector3.FORWARD:
			masklayer = 13 # -Z 
			glooby.set_cull_mask_value(13,true)
		Vector3.BACK:
			masklayer = 14 # Z
			glooby.set_cull_mask_value(14,true)
		_:
			masklayer = 15 # Undefined Direction
			glooby.set_cull_mask_value(15,true)
	glooby.set_cull_mask_value(masklayer,true)
	pass
	
	
func movement_process(obtained_quat: Quaternion, grav_quat: Quaternion, modified_force_strength: float) -> void:
	var torque_movement = Vector3(0,0,0)
	var force_movement = Vector3(0,0,0)
	
	if Input.is_action_pressed("rotate_left"):
		torque_movement += Vector3.BACK
		force_movement += Vector3.LEFT
		begin_countdown = true
	if Input.is_action_pressed("rotate_right"):
		torque_movement += Vector3.FORWARD
		force_movement += Vector3.RIGHT
		begin_countdown = true
	if Input.is_action_pressed("rotate_forward"):
		torque_movement += Vector3.LEFT
		force_movement += Vector3.FORWARD
		begin_countdown = true
	if Input.is_action_pressed("rotate_back"):
		torque_movement += Vector3.RIGHT
		force_movement += Vector3.BACK
		begin_countdown = true
		
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
	if begin_countdown && !br8k_countdown:
		CountDownNode.visible = true
		start_countdown -= delta
		CountdownNumbersText.text = str(int(start_countdown+1))
		if start_countdown <= 0:
			can_move = true
			has_gravity = true
			run_timer = true
			br8k_countdown = true
			CountDownNode.visible = false
	
	if !has_won:
		if has_gravity:
			apply_central_force(gravity_direction*gravity)
		
		var obtained_quat = camera_node.get_quat_no_vert()
		var obtained_quat_with_vert = camera_node.quaternion
		var grav_quat = relative_down_node.quaternion
		
		camera_controller.set_camera_fov(self.linear_velocity.length())
		
			
		var should_regen_tick = (ground_touch_timer > 0 || (self.angular_velocity.length() <= 0.00009 && self.linear_velocity.length() <= 0.00009))
		
		if dashes < max_dashes && should_regen_tick:
			dash_regen_timer += delta
		
		if dash_regen_timer >= 1.5 && dashes < max_dashes && should_regen_tick:
			dashes += 1
			if dashes != max_dashes:
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
		
		refill_meter.set_percentage((dash_regen_timer + dashes*1.5)/ (max_dashes*1.5) * 100)
		dashes_bar.set_percentage( (dashes/max_dashes) * 100.0)
		
		
		if Input.is_action_just_pressed("jump",false) && jumps > 0 && can_move:
			if (self.linear_velocity*gravity_direction.abs()).normalized() == gravity_direction:
				self.linear_velocity += self.linear_velocity*(gravity_direction.abs()*-1)
				pass
			apply_impulse((grav_quat *(obtained_quat *Vector3.UP))*jump_strength)
			jumps -= 1
			
		jumps_bar.set_percentage((jumps/max_jumps)*100.0)
		
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
	else:
		linear_velocity = linear_velocity * .99
		apply_force((win_target.global_position-self.global_position)*50)
		pass
		
		
	
func _process(delta: float) -> void:
	if !has_won:
		if run_timer:
			level_time += delta
		
		var stored = abs(floori(level_time * 1000))
		var miliseconds = 0
		var seconds = 0
		var minutes = 0
		var hours = 0
		
		hours = floori(stored/3600000)
		stored %= 3600000
		minutes = floori(stored/60000)
		stored %= 60000
		seconds = floori(stored / 1000)
		miliseconds = stored % 1000
		
		var bgseconds = "8".repeat(("%s" % seconds).length())
		var bgminutes = "8".repeat(("%s" % minutes).length())
		var bghours = "8".repeat(("%s" % hours).length())
		#TimerBox.text = "%02.0f" % hours + ":" + "%02.0f" % minutes + ":" + "%02.0f" % seconds + ":" + "%003.0f" % miliseconds
		if(hours > 0):
			TimerBox.text = "%02d:%02d:%02d.[font_size=38]%03d[/font_size]" % [hours, minutes, seconds, miliseconds]
			TimerBackgroundBox.text = bghours+":88:88.[font_size=38]888[/font_size]"
			VictoryTimerBox.text = "%02d:%02d:%02d.[font_size=86]%03d[/font_size]" % [hours, minutes, seconds, miliseconds]
			VictoryTimerBackgroundBox.text = bghours+":88:88.[font_size=86]888[/font_size]"
		else: 
			if(minutes > 0):
				TimerBox.text = "%01d:%02d.[font_size=38]%03d[/font_size]" % [minutes, seconds, miliseconds]
				TimerBackgroundBox.text = bgminutes+":88.[font_size=38]888[/font_size]"
				VictoryTimerBox.text = "%01d:%02d.[font_size=86]%03d[/font_size]" % [minutes, seconds, miliseconds]
				VictoryTimerBackgroundBox.text = bgminutes+":88.[font_size=86]888[/font_size]"
			else:
				TimerBox.text = "%01d.[font_size=38]%03d[/font_size]" % [seconds, miliseconds]
				TimerBackgroundBox.text = bgseconds + ".[font_size=38]888[/font_size]"
				VictoryTimerBox.text = "%01d.[font_size=86]%03d[/font_size]" % [seconds, miliseconds]
				VictoryTimerBackgroundBox.text = bgseconds + ".[font_size=86]888[/font_size]"
		
		if Input.is_action_just_pressed("pause",false) && !skipframe:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			pause_menu._showma()
			CountDownNode.visible = false
			get_tree().paused = true
			skipframe = true
			pass
		if skipframe:
			skipframe = false
		pass
		
		
	
func get_has_won():
	return has_won
		
func restart_level():
	get_tree().reload_current_scene()
	
func _on_cube_hitbox_area_entered(area: Area3D) -> void:
	DebugDraw2D.set_text("Area Collision Layer", area.collision_layer)
	if area.get_collision_layer_value(2):
		set_gravity_direction(area.get_stored_gravity_direction())
		pass
	if area.get_collision_layer_value(3):
		set_gravity_direction(checkpoint.get_checkpoint_gravity_direction())
		relative_down_node.reset_camera_down(checkpoint.get_checkpoint_gravity_direction())
		self.position = checkpoint.global_position + checkpoint.get_respawn_offset()
		self.linear_velocity = Vector3()
		jumps = max_jumps
		slams = 1
		dashes = max_dashes
		can_move = false
		pass
	if area.get_collision_layer_value(4):
		print(area)
		checkpoint = area
		pass
	if area.get_collision_layer_value(5) && !has_won:
		win_target = area
		LevelNameText.text = SceneRoot.get_level_name()
		
		if level_time*1000 <= t_rank_time:
			level_rank.text = "[color=#b0f2ff]T"
		elif level_time*1000 <= s_rank_time:
			level_rank.text = "[color=#D3AF37]S"
		elif level_time*1000 <= a_rank_time:
			level_rank.text = "[color=#2bd41c]A"
		elif level_time*1000 <= b_rank_time:
			level_rank.text = "[color=#ac1cd4]B"
		elif level_time*1000 <= c_rank_time:
			level_rank.text = "[color=#431cd4]C"
		elif level_time*1000 <= d_rank_time:
			level_rank.text = "[color=#d4781c]D"
		else:
			level_rank.text = "[color=#d4341c]F"
		
		#get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#print(level_time*1000.0000)
		has_won = true
		print("calling uploadscore")
		SceneRoot.uploadscore(level_time*1000.0000)
		#Steam.uploadLeaderboardScore(level_time*1000.0000)
		#VictoryTimerBox.text = TimerBox.text
		VictoryScreen.show()
		PlayerUI.hide()
		Steam.findLeaderboard("Tutorial Fastest Time")
		pass
	pass # Replace with function body.


func _on_cube_collision_detector_body_entered(body: Node3D) -> void:
	#print(body)
	
	if body is StaticBody3D:
		var collision_shape = body as StaticBody3D
		if collision_shape.get_collision_mask_value(masklayer):
			jumps = max_jumps
			slams = 1
			can_move = true;
			ground_touch_timer = 1
			pass
		pass
	pass # Replace with function body.
