extends Node

@export var main_cam:Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#shadow setup
	$SubViewport.get_node("Camera2D").zoom = Vector2(1.000001, 1.00000)
	$Background.material.set_shader_parameter("shadowtex", $SubViewport.get_texture())
	
	
	
	for i in Global.passed_image.size():
		
		#var new_layer:CanvasLayer = CanvasLayer.new()
		var new_sprite:Sprite2D = Sprite2D.new()
		
		new_sprite.texture = ImageTexture.create_from_image(Global.passed_image[i])
		new_sprite.offset = Global.level_size / 2
		
		new_sprite.material = Global.parallax_mat
		new_sprite.set_instance_shader_parameter("layer", Global.passed_scale[i])
		
		add_child(BackBufferCopy.new())
		add_child(new_sprite)
		
		#new_layer.follow_viewport_scale = Global.passed_scale[i]
		#new_layer.follow_viewport_enabled = true
		
		#new_layer.add_child(new_sprite)
		#add_child(new_layer)
		
	
	
	$RigidBody2D/Camera2D.limit_bottom = Global.level_size.y
	$RigidBody2D/Camera2D.limit_right = Global.level_size.x
	$RigidBody2D/Camera2D.limit_top = 0
	$RigidBody2D/Camera2D.limit_left = 0
	
	#var running_total:Array[PackedVector2Array] = [Global.pLayer_collision_polys[0]]
	
	
	#for p in Global.pLayer_collision_polys:
		
	#	running_total = Geometry2D.merge_polygons(p, running_total[0])
		
		
		
	
	
	for p in Global.pLayer_collision_polys:
		
		if p.is_empty():
			continue
		
		var poly:CollisionPolygon2D = CollisionPolygon2D.new()
		poly.polygon = p
		
		$LevelCollision.add_child(poly)
		
	
	#$StaticBody2D.position = Vector2(640, 360) / 2
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	
	#maintain shadows
	#main_cam.get_screen_center_position()
	var cam_pos:Vector2 = main_cam.global_position / Vector2(640, 360) - Vector2(.5, .5)
	Global.parallax_mat.set_shader_parameter("camera_position", cam_pos)
	
	$SubViewport.get_node("Camera2D").position = main_cam.global_position - Vector2(640, 360) / 2
	pass
