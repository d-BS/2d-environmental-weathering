extends Node

var cam_delta:Vector2
@export var shadow_mat:ShaderMaterial
var light_direction:Vector2 = Vector2(-.2, -.2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	cam_delta.y = get_viewport().get_visible_rect().size.y / 4
	cam_delta.x = get_viewport().get_visible_rect().size.x / 4
	#cam_delta = Vector2.ZERO
	print(cam_delta)
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	if Input.is_action_pressed("arrow_down"):
		
		$Camera2D.position = Vector2(0, cam_delta.y)
		
	elif Input.is_action_pressed("arrow_up"):
		
		$Camera2D.position = Vector2(0, -cam_delta.y)
		
	elif Input.is_action_pressed("arrow_left"):
		
		$Camera2D.position = Vector2(-cam_delta.x, 0)
		
	elif Input.is_action_pressed("arrow_right"):
		
		$Camera2D.position = Vector2(cam_delta.x, 0)
	else:
		$Camera2D.position = Vector2(0, 0)
	
	#var temp = light_direction
	#just ignore the magic numbers for now
	#temp += $Camera2D.get_screen_center_position() / get_viewport().get_visible_rect().size.y - Vector2(0.688889, 0.3)
	#shadow_mat.set_shader_parameter("light_direction", temp)
	pass
