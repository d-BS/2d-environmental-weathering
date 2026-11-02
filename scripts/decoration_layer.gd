@tool
class_name DecorationLayer extends CanvasLayer


@export var distance:float = 1:
	set(value):
		if value < 0:
			value = 0
		distance = value
		follow_viewport_scale = 1 / value


@export var tiles:TileMapLayer
@export var sprite:Sprite2D

func ready():
	
	follow_viewport_scale = 1 / distance
	
	follow_viewport_enabled = true
	pass


func set_tiles():
	
	tiles = TileMapLayer.new()
	tiles.tile_set = load("res://assets/blob_tile_set.tres")
	add_child(tiles)
	
	
	

func set_sprite_tex(tex:Texture2D):
	
	sprite = Sprite2D.new()
	add_child(sprite)
	sprite.texture = tex
	

func set_sprite_img(img:Image):
	
	sprite = Sprite2D.new()
	add_child(sprite)
	sprite.texture = ImageTexture.create_from_image(img)
	
