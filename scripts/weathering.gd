extends Node

@onready var sprite:Sprite2D = $Node2D/Sprite2D
@export var noise:FastNoiseLite

var color_palette:Array[Color] = [\
	Color("BLACK"), \
	Color("DIM_GRAY"), \
	Color("WEB_GRAY"), \
	Color("DARK_GRAY"), \
	Color("GRAY"), \
	Color("Gainsboro"), \
	Color("White")
]

var map_size:Vector2i = Vector2i(640, 360)

var image_data:PackedColorArray
var image:Image
var image_tex: ImageTexture

var update_tex:bool = false

func _ready() -> void:
	
	
	
	#image_data[image_data.size()/2] = Vector4(0, 0, 0, 1)
	
	if Global.passed_image == null:
		#map_size = Vector2i(640, 360)
		image_data.resize(map_size.x*map_size.y)
		image_data.fill(Color(0, 0, 0, 0))
		create_rect(Vector2i(30, 30), Vector2i(500,60), Color(0, 0, 0, 1))
		image = Image.create_from_data(map_size.x, map_size.y, false, Image.FORMAT_RGBAF, image_data.to_byte_array())
		image_tex = ImageTexture.create_from_image(image)
		sprite.texture = image_tex
		
	else:
		
		image_data = rgba8_bytes_to_Color(Global.passed_image.get_data())
		image = Image.create_from_data(map_size.x, map_size.y, false, Image.FORMAT_RGBAF, image_data.to_byte_array())
		
		#print(Global.passed_image)
		
		pass
	
	#image = Image.create_from_data(map_size.x, map_size.y, false, Image.FORMAT_RGBAF, image_data.to_byte_array())
	image_tex = ImageTexture.create_from_image(image)
	
	sprite.texture = image_tex
	sprite.offset = Vector2(map_size) / 2
	
	
	
	pass



func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_accept"):
		
		apply_rule(weather_step)
		
		pass
	
	if Input.is_action_just_pressed("arrow_up"):
		
		apply_rule(slime_step)
		
		pass
	
	
	_excecute_queued_update_tex()
	
	pass


## currently has no bounds checking, also does not update image, only image_data
func create_rect(position:Vector2i, size:Vector2i, color:Color):
	
	for x in size.x:
		for y in size.y:
			
			image_data[position.x + x + position.y * map_size.x + y * map_size.x] \
						= color
			
			pass
	
	queue_update_tex()
	

## applies passed rule to every pixel.
func apply_rule(to_call:Callable):
	
	var img_temp:PackedColorArray = image_data.duplicate()
	
	for i in image_data.size():
		
		to_call.call(i, img_temp)
		
		pass
	
	image_data = img_temp
	queue_update_tex()



func weather_step(i:int, img_temp:PackedColorArray):
	
	if(image_data[i].a == 0.0):
			return
		
	
	var neighbors:Array[Vector2i] = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
	
	for n in neighbors:
		
		#checks bounds
		var nay:Vector2i = n + Vector2i(i % map_size.x, i / map_size.x)
		if nay.x >= map_size.x || nay.x < 0 || nay.y >= map_size.y || nay.y < 0:
			continue
		
		if image_data[i + n.x + n.y * map_size.x].a == 0 && 1 > floor(noise.get_noise_2d(i % map_size.x, i / map_size.x) + 1.1):
			img_temp[i].a = 0
			return
		
	
	
	pass

func slime_step(i:int, img_temp:PackedColorArray):
	
	if(image_data[i].a != 0.0):
		return
	
	var neighbors:Array[Vector2i] = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
	
	for n in neighbors:
		
		var nay:Vector2i = n + Vector2i(i % map_size.x, i / map_size.x)
		if nay.x >= map_size.x || nay.x < 0 || nay.y >= map_size.y || nay.y < 0:
			continue
		
		if image_data[i + n.x + n.y * map_size.x].a != 0:
			img_temp[i].a = 1
			return
		
	
	
	pass

func queue_update_tex():
	update_tex = true
func _excecute_queued_update_tex():
	if update_tex:
		image.set_data(map_size.x,  map_size.y, false, Image.FORMAT_RGBAF, image_data.to_byte_array())
		image_tex.update(image)
		pass
	update_tex = false


func _on_selection_box_made(box: Rect2i) -> void:
	
	create_rect(box.position, box.size, Color(.5, .5, .5, 1))
	
	pass # Replace with function body.

func rgba8_bytes_to_Color(img:PackedByteArray) -> PackedColorArray:
	
	var toReturn:PackedColorArray = []
	toReturn.resize(img.size() / 4)
	
	for i in toReturn.size():
		
		var r:float = img[i * 4] / 255.0
		var g:float = img[i * 4 + 1] / 255.0
		var b:float = img[i * 4 + 2] / 255.0
		var a:float = img[i * 4 + 3] / 255.0
		toReturn[i] = Color(r, g, b, a)
		
		pass
	
	return toReturn
	
