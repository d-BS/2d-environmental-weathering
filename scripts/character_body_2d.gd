extends RigidBody2D


@export var feet:RigidBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -150.0
var crouch_power = 500

#normally 75000
var upright_strength = 70000

func _ready() -> void:
	
	pass


func _physics_process(delta: float) -> void:
	
	if feet.position.is_equal_approx(position):
		print("Jump catching!")
		apply_central_force(Vector2(0, JUMP_VELOCITY))
	
	var rot = rotation
	#var deadzone = PI / 8
	
	rot = pow(abs(rot), 2) * sign(rot)
	
	#if abs(rot) <= deadzone:
	#	rot = 0
	
	clampf(angular_velocity, .05, .05)
	if is_inf(angular_velocity): angular_velocity = 0
	
	apply_torque(-rot * upright_strength)
	
	apply_torque(-angular_velocity * 1000)
	
	
	pass

func _process(delta: float) -> void:
	
	
	
	# Handle jump.
	if Input.is_action_just_pressed("arrow_up"): #and is_on_floor():
		
		
		var jump_str:float = JUMP_VELOCITY + clampf(linear_velocity.y, -50, 100)
		
		
		feet.apply_central_impulse(Vector2(0, jump_str))
		apply_central_impulse(Vector2(0, jump_str))
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("arrow_left", "arrow_right")
	
	if direction:
		
		var move_dir:Vector2 = Vector2(direction * SPEED, 0).rotated(rotation)
		
		apply_central_force(move_dir)
		feet.apply_torque(direction * SPEED)
		
	
	if Input.is_action_pressed("arrow_down"):
		
		
		
		var crouch_dir:Vector2 = Vector2(0, crouch_power).rotated(rotation)
		
		apply_central_force(crouch_dir)
		feet.apply_central_force(-crouch_dir)
		
		pass
	
	
	pass
