extends Node2D



var size: Vector2i = Vector2i(100,100)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	#mat.set_shader_parameter("weather_step", false)
	
	
	
	
	
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
	
	#await 
	
	
	
	var viewport_texture:ViewportTexture = subviewport.get_texture()
	
	
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	
	
	var buffer_image:Image = viewport_texture.get_image()
	
	if buffer_image == null:
		printerr("buffer image is null")
		return
	
	#$CharacterBody2D/Sprite2D.texture = ImageTexture.create_from_image(buffer_image)
	#get_tree().paused = true
	
	Global.passed_image = [buffer_image]
	#Global.passed_texture = viewport_texture
	
	
	
	
	
	
	
	
	
	#here we extract the collision shape
	var space_state = PhysicsServer2D.space_get_direct_state(tile_to_move.get_world_2d().space)
	var query = PhysicsShapeQueryParameters2D.new()
	var q_shape = RectangleShape2D.new()
	
	#this should be whatever the level size is 
	q_shape.size = Vector2(640, 360) * 10
	query.shape_rid = q_shape
	#this may have to be updated
	query.transform = tile_to_move.global_transform
	
	
	#maybe the max should be different than this, but that's a later problem
	var collision_bodies:Array[Dictionary] = space_state.intersect_shape(query, tile_to_move.get_used_cells().size())
	
	for b in collision_bodies:
		
		var sub_shape:RID = PhysicsServer2D.body_get_shape(b.rid, b.shape)
		var quad_pts:PackedVector2Array = PhysicsServer2D.shape_get_data(sub_shape)
		var b_transform:Transform2D = PhysicsServer2D.body_get_state(b.rid, PhysicsServer2D.BODY_STATE_TRANSFORM)
		
		
		var pts_to_return:PackedVector2Array = []
		
		for p in quad_pts:
			pts_to_return.append(-p * b_transform * -1)
		
		Global.pLayer_collision_polys.append(pts_to_return)
		
		pass
	
	
	
	
	
	
	
	
	
	
	Global.set_scene("res://scenes/weathering_step.tscn")
	
	
	
	pass # Replace with function body.


func _on_shadow_pressed() -> void:
	
	Global.set_scene("res://scenes/shadow_scene.tscn")
	
	
	pass # Replace with function body.


func _on_sleep_pressed() -> void:
	
	if $CharacterBody2D.upright_strength == 0:
		$CharacterBody2D.upright_strength = 70000
	else: $CharacterBody2D.upright_strength = 0
	
	pass # Replace with function body.
