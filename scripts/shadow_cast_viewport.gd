extends SubViewport

@export var main_cam:Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	world_2d = main_cam.get_viewport().find_world_2d()
	
	#shadow setup
	$Camera2D.zoom = Vector2(1.000001, 1.000001)
	Global.parallax_mat.set_shader_parameter("shadowtex", get_texture())
	
	RenderingServer.global_shader_parameter_set("light_pos", Vector3(0, 50, -10))#(640/2.0, 360/2.0, 0))
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#maintain shadows
	#main_cam.get_screen_center_position()
	var cam_pos:Vector2 = main_cam.get_screen_center_position()
	RenderingServer.global_shader_parameter_set("camera_position", Vector3(cam_pos.x, cam_pos.y, 0))
	
	#RenderingServer.global_shader_parameter_set("light_pos", Vector3(main_cam.global_position.x, main_cam.global_position.y, 0))
	
	$Camera2D.position = cam_pos - Vector2(640, 360) / 2
	
	
	pass
