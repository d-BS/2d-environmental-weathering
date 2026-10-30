extends Node

@export var playerLayer:CanvasLayer
#@export var UILayer:CanvasLayer
@export var tile_choice:OptionButton

var curr_tile_layer:TileMapLayer
var curr_tile_source:TileSetAtlasSource

var curr_placing_tile:Vector2i = Vector2i(0,0)

var mouse_down:bool = false

var mouse_tiles:Array[Vector2i] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	curr_tile_layer = $PlayerLayer/TextureTiles
	curr_tile_source = curr_tile_layer.tile_set.get_source(0)
	
	setup_tile_dropdown(curr_tile_source)
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action("rclick"):
		
		curr_tile_layer.erase_cell(curr_tile_layer.get_global_mouse_position() / 20)
		
	
	
	#if Input.is_action_just_pressed("click"):
	if event.is_action_pressed("click"):
		
		mouse_down = true
		mouse_tiles = []
		mouse_tiles.append(curr_tile_layer.get_global_mouse_position() / 20)
		
		curr_tile_layer.set_cell(mouse_tiles[0], 0, curr_placing_tile)
		
	
	
	if mouse_down:
		
		#curr_tile_layer.set_cells_terrain_connect([])
		
		var mouse_pos:Vector2i = curr_tile_layer.get_global_mouse_position() / 20
		
		if(mouse_pos != mouse_tiles.back()):
			mouse_tiles.append(mouse_pos)
			curr_tile_layer.set_cells_terrain_connect(mouse_tiles, 0, 0, false)
			
			
		
		
		
		#if(mouse_tile!=mouse_tile_prev):
			#curr_tile_layer.set_cells_terrain_connect([mouse_tile_prev,  mouse_tile], 0, 0, false)
		#	curr_tile_layer.set_cells_terrain_connect([mouse_tile], 0, 0, true)
		#else:
		#	curr_tile_layer.set_cell(mouse_tile, 0, curr_placing_tile)
	
	
	
	if mouse_down && event.is_action_released("click"):
		
		mouse_down = false
		mouse_tiles.clear()
		
		pass
	
	
	
	
	pass


func setup_tile_dropdown(tile_source: TileSetAtlasSource):
	
	#var tiles:Array[ImageTexture] = []
	var atlasImage:Image = tile_source.texture.get_image()

	for i in tile_source.get_tiles_count():
		
		var tile_image:Image = atlasImage.get_region(tile_source.get_tile_texture_region(tile_source.get_tile_id(i)))
		var tile_texture:ImageTexture = ImageTexture.create_from_image(tile_image)
		
		tile_choice.add_icon_item(tile_texture, "", i)
		
	

func get_neighborhood(cell:Vector2i) -> Array[Vector2i]:
	
	
	var neighborhood:Array[TileSet.CellNeighbor] = [\
	TileSet.CELL_NEIGHBOR_TOP_SIDE,\
	TileSet.CELL_NEIGHBOR_TOP_RIGHT_CORNER,\
	TileSet.CELL_NEIGHBOR_RIGHT_SIDE,\
	TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER,\
	TileSet.CELL_NEIGHBOR_BOTTOM_SIDE,\
	TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER,\
	TileSet.CELL_NEIGHBOR_LEFT_SIDE,\
	TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER,\
	]
	
	var toReturn:Array[Vector2i] = []
	
	toReturn.append(cell)
	
	for n in neighborhood:
		
		toReturn.append(curr_tile_layer.get_neighbor_cell(cell, n))
		
	
	return toReturn
	


func _on_tile_choice_item_selected(index: int) -> void:
	
	curr_placing_tile = curr_tile_source.get_tile_id(tile_choice.get_item_id(index))
	
	pass # Replace with function body.
