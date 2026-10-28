extends Node2D


var camera_speed:float = 100

var size: Vector2i = Vector2i(100,100)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	#mat.set_shader_parameter("weather_step", false)
	
	
	if Input.is_action_pressed("arrow_down"):
		
		$Camera2D.position.y += camera_speed * delta
		
	if Input.is_action_pressed("arrow_up"):
		
		$Camera2D.position.y -= camera_speed * delta
		
	if Input.is_action_pressed("arrow_left"):
		
		$Camera2D.position.x -= camera_speed * delta
		
	if Input.is_action_pressed("arrow_right"):
		
		$Camera2D.position.x += camera_speed * delta
		
	
	
	
	
	
	
	pass


func _on_step_pressed() -> void:
	
	var sub_container:SubViewportContainer = SubViewportContainer.new()
	var subviewport:SubViewport = SubViewport.new()
	subviewport.transparent_bg = true
	
	
	add_child(sub_container)
	sub_container.add_child(subviewport)
	
	var tile_to_move:TileMapLayer = $TileMapLayer
	remove_child(tile_to_move)
	subviewport.add_child(tile_to_move)
	subviewport.size = Vector2i(640, 360)#tile_to_move.get_used_rect().size * tile_to_move.tile_set.tile_size
	#print(tile_to_move.get_used_rect().size * tile_to_move.tile_set.tile_size)
	
	await RenderingServer.frame_post_draw
	
	var viewport_texture:ViewportTexture = subviewport.get_texture()
	var buffer_image:Image = viewport_texture.get_image()
	
	Global.passed_image = buffer_image
	Global.set_scene("res://weathering.tscn")
	
	pass # Replace with function body.
