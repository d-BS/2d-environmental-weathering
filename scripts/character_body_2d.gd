extends RigidBody2D


@export var feet:RigidBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -150.0
const CROUCH_POWER = 1000
var upright_strength = 70000

var head_on_ground:bool = false
var foot_on_ground:bool = false


const CAYOTE_MAX:float = .2
var cayote_time:float = 0

const JUMP_COOLDOWN:float = CAYOTE_MAX
var j_cooldown_time:float = 0


## Different Cog types:

#dark teeth, dull
#Sm rect:[P: (110.0, 48.0), S: (9.0, 9.0)]
#Lg rect:[P: (109.0, 89.0), S: (13.0, 13.0)]

#dark teeth, bladed
#Sm rect:[P: (121.0, 48.0), S: (9.0, 9.0)]
#Lg rect:[P: (123.0, 89.0), S: (13.0, 13.0)]

#light teeth, bladed
#Sm rect:[P: (219.0, 63.0), S: (9.0, 9.0)]
#Lg rect:[P: (217.0, 47.0), S: (13.0, 13.0)]



func _ready() -> void:
	
	#print("Sm rect:", $TorsoSprite/SmCog.region_rect)
	#print("Lg rect:", $TorsoSprite/LgCog.region_rect)
	
	pass


func _physics_process(delta: float) -> void:
	
	if feet.position.is_equal_approx(position):
		printerr("Jump catching!")
		apply_central_force(Vector2(0, JUMP_VELOCITY))
	
	var rot = rotation
	#var deadzone = PI / 8
	
	rot = pow(abs(rot), 2) * sign(rot)
	
	#if abs(rot) <= deadzone:
	#	rot = 0
	
	clampf(angular_velocity, .05, .05)
	if is_inf(angular_velocity): angular_velocity = 0
	
	
	#tries to keep upright
	apply_torque(-rot * upright_strength)
	
	#damps motion
	apply_torque(-angular_velocity * 1000)
	
	
	
	
	# Handle jump.
	
	var can_jump:bool = false
	var wants_jump:bool = Input.is_action_just_pressed("arrow_up")
	
	#cayote timer
	if cayote_time > 0: cayote_time -= delta
	if cayote_time < 0: cayote_time = 0
	
	#jump cooldown
	if j_cooldown_time > 0: j_cooldown_time -= delta
	if j_cooldown_time < 0: j_cooldown_time = 0
	
	foot_on_ground = !feet.get_colliding_bodies().is_empty()
	
	if (foot_on_ground || head_on_ground): #and is_on_floor():
		
		cayote_time = CAYOTE_MAX
		
	
	can_jump = cayote_time > 0 && j_cooldown_time == 0
	
	
	if wants_jump && can_jump:
		
		var jump_str:float = JUMP_VELOCITY + clampf(linear_velocity.y, -50, 100)
		
		feet.apply_central_impulse(Vector2(0, jump_str))
		apply_central_impulse(Vector2(0, jump_str))
		
		cayote_time = 0
		j_cooldown_time = JUMP_COOLDOWN
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("arrow_left", "arrow_right")
	
	if direction:
		
		var move_dir:Vector2 = Vector2(direction * SPEED, 0)#.rotated(rotation)
		
		apply_central_force(move_dir)
		feet.apply_torque(direction * SPEED)
		
	
	if Input.is_action_pressed("arrow_down"):
		
		
		var crouch_dir:Vector2 = Vector2(0, CROUCH_POWER).rotated(rotation)
		
		apply_central_force(crouch_dir)
		feet.apply_central_force(-crouch_dir)
		
		pass
	
	
	pass

func _process(delta: float) -> void:
	
	
	
	#Apply rotations (Simple implementation)
	#const rot_snap = deg_to_rad(22.5)
	
	var rot:float = feet.rotation
	
	#$TorsoSprite/LgCog.rotation = round(rot/rot_snap) * rot_snap
	#$TorsoSprite/SmCog.rotation = -round(rot/rot_snap) * rot_snap
	
	$TorsoSprite/LgCog.rotation = rot
	$TorsoSprite/SmCog.rotation = -rot
	
	pass

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	
	
	head_on_ground = state.get_contact_count() && state.get_contact_local_position(0).y > position.y
	
	
	pass
