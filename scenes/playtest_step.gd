extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	$Sprite2D.texture = ImageTexture.create_from_image(Global.passed_image[0])
	$Sprite2D.position = Vector2(640, 360) / 2
	
	#var running_total:Array[PackedVector2Array] = [Global.pLayer_collision_polys[0]]
	
	
	#for p in Global.pLayer_collision_polys:
		
	#	running_total = Geometry2D.merge_polygons(p, running_total[0])
		
		
		
	
	#print(running_total)
	
	for p in Global.pLayer_collision_polys:
		
		var poly:CollisionPolygon2D = CollisionPolygon2D.new()
		poly.polygon = p
		$StaticBody2D.add_child(poly)
		
	
	#$StaticBody2D.position = Vector2(640, 360) / 2
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
