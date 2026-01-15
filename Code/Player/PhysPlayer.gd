extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var torque_strength = 0.5  # Adjust as needed
var max_angular_speed = 20.0  # Radians per second

# default gravity value (make me maluable! so we can have silly gravity levels and gravity changes)
var gravity = 9.8 

# this should be defineable on a per level basis and easily accessed by gravity changers
# additionally this will be what tells us what the cameras relative down is
var gravity_direction = Vector3.DOWN

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var isOverspeed = angular_velocity.length() < max_angular_speed;
	
	apply_central_force(gravity_direction*gravity)
	
	if Input.is_action_pressed("rotate_left") and isOverspeed:
		apply_torque_impulse(Vector3.LEFT * torque_strength)
	if Input.is_action_pressed("rotate_right") and isOverspeed:
		apply_torque_impulse(Vector3.RIGHT * torque_strength)
	if Input.is_action_pressed("rotate_forward") and isOverspeed:
		apply_torque_impulse(Vector3.FORWARD * torque_strength)
	if Input.is_action_pressed("rotate_back") and isOverspeed:
		apply_torque_impulse(Vector3.BACK * torque_strength)
	pass
