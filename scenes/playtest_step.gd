extends Node

@export var main_cam:Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#$ShadowCast.world_2d = get_viewport().find_world_2d()
	
	for i in Global.passed_image.size():
		
		#var new_layer:CanvasLayer = CanvasLayer.new()
		var new_sprite:Sprite2D = Sprite2D.new()
		
		new_sprite.texture = ImageTexture.create_from_image(Global.passed_image[i])
		new_sprite.offset = Global.level_size / 2
		
		new_sprite.material = Global.parallax_mat
		new_sprite.set_instance_shader_parameter("layer", Global.passed_scale[i])
		
		var bbuffer:BackBufferCopy = BackBufferCopy.new()
		add_child(bbuffer)
		bbuffer.set_owner(self)
		
		
		add_child(new_sprite)
		new_sprite.set_owner(self)
		
		
		#new_layer.follow_viewport_scale = Global.passed_scale[i]
		#new_layer.follow_viewport_enabled = true
		
		#new_layer.add_child(new_sprite)
		#add_child(new_layer)
		
	
	
	main_cam.limit_bottom = Global.level_size.y
	main_cam.limit_right = Global.level_size.x
	main_cam.limit_top = 0
	main_cam.limit_left = 0
	
	
	
	for p in Global.pLayer_collision_polys:
		
		if p.is_empty():
			continue
		
		var poly:CollisionPolygon2D = CollisionPolygon2D.new()
		poly.polygon = p
		
		$LevelCollision.add_child(poly)
		poly.set_owner(self)
		
	
	#$StaticBody2D.position = Vector2(640, 360) / 2
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
