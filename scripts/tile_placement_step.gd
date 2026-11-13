extends Node2D

@export var playerLayer:CanvasLayer

var playerLayerTiles:TileMapLayer
@export var tile_choice:OptionButton


#options when messing with any particular layer -
#	change bgColor 
#	set tint / modulate
#	set layer distance
#	new layer
#	(add property tiles? lighting / effects?)


var level_size:Vector2i

var bgLayers:Array[CanvasLayer]
var fgLayers:Array[CanvasLayer]

var curr_canvas:CanvasLayer
var curr_tile_layer:TileMapLayer
var curr_tile_source:TileSetAtlasSource

var curr_placing_tile:Vector2i = Vector2i(0,0)

var mouse_down:bool = false

var mouse_tiles:Array[Vector2i] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	level_size = Global.level_size
	
	#playerLayer.set_tiles()
	#$FgLayer1.set_tiles()
	
	fgLayers.append($FgLayer1)
	
	
	playerLayerTiles = playerLayer.get_node("TileMapLayer")
	curr_canvas = playerLayer
	curr_tile_layer = playerLayerTiles
	#curr_tile_layer = $TileMapLayer
	curr_tile_source = curr_tile_layer.tile_set.get_source(0)
	
	
	setup_tile_dropdown(curr_tile_source)
	
	setup_layer_dropdown()
	
	queue_redraw()
	
	pass # Replace with function body.


func _draw() -> void:
	
	draw_rect(Rect2i(Vector2i.ZERO, level_size), Color.AQUA, false)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

func _unhandled_input(event: InputEvent) -> void:
	
	
	var mouse_pos:Vector2i = curr_tile_layer.get_local_mouse_position() / 20
	
	
	if event.is_action("rclick"):
		
		curr_tile_layer.erase_cell(mouse_pos)
		
	
	
	#if Input.is_action_just_pressed("click"):
	if event.is_action_pressed("click"):
		
		mouse_down = true
		mouse_tiles = []
		mouse_tiles.append(mouse_pos)
		
		curr_tile_layer.set_cell(mouse_tiles[0], 0, curr_placing_tile)
		
		
	
	
	if mouse_down:
		
		
		if(mouse_pos != mouse_tiles.back()):
			mouse_tiles.append(mouse_pos)
			curr_tile_layer.set_cells_terrain_connect(mouse_tiles, 0, 0, false)
			
			
		
	
	if mouse_down && event.is_action_released("click"):
		
		mouse_down = false
		mouse_tiles.clear()
		
		pass
	
	
	
	
	
	pass

## as the number of tiles increases, this will likely need
## to expand in complexity
func setup_tile_dropdown(tile_source: TileSetAtlasSource):
	
	
	var atlasImage:Image = tile_source.texture.get_image()
	
	for i in tile_source.get_tiles_count():
		
		var tile_image:Image = atlasImage.get_region(tile_source.get_tile_texture_region(tile_source.get_tile_id(i)))
		var tile_texture:ImageTexture = ImageTexture.create_from_image(tile_image)
		
		tile_choice.add_icon_item(tile_texture, "", i)
		
	

func setup_layer_dropdown():
	
	for f in fgLayers:
		
		
		pass
	
	$UILayer/LayerChoice.add_item("PlayerLayer", 1)
	$UILayer/LayerChoice.add_item("FgLayer1", .5)
	
	
	
	pass


## probably not needed, remove later
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


## this function converts every layer to colordata,
## extracts the collision polygons, and swaps to the new state
func _on_rasterize_button_pressed() -> void:
	
	#Here we create the viewport where the rasterization will
	#be done
	var sub_container:SubViewportContainer = SubViewportContainer.new()
	var subviewport:SubViewport = SubViewport.new()
	subviewport.transparent_bg = true
	
	var viewport_texture:ViewportTexture = subviewport.get_texture()
	
	add_child(sub_container)
	sub_container.add_child(subviewport)
	
	
	var to_rasterize:Array[CanvasLayer] = [playerLayer]
	to_rasterize.append_array(bgLayers)
	to_rasterize.append_array(fgLayers)
	
	Global.level_size = level_size
	Global.passed_image = []
	
	for l in to_rasterize:
		
		for c in subviewport.get_children(false):
			subviewport.remove_child(c)
			add_child(c)
		
		remove_child(l)
		subviewport.add_child(l)
		
		#this will need to be updated so that it scales based on how
		#far back the layer is
		subviewport.size = level_size
		
		await RenderingServer.frame_post_draw
		await RenderingServer.frame_post_draw
		
		var buffer_image:Image = viewport_texture.get_image()
		
		
		if buffer_image == null:
			printerr("buffer image is null")
			return
		
		Global.passed_image.append(buffer_image)
		
		pass
	
	
	
	#here we extract the collision shape
	var space_state = PhysicsServer2D.space_get_direct_state(playerLayerTiles.get_world_2d().space)
	var query = PhysicsShapeQueryParameters2D.new()
	var q_shape = RectangleShape2D.new()
	
	#this should be whatever the level size is 
	q_shape.size = level_size * 3
	query.shape_rid = q_shape
	#this may have to be updated
	query.transform = playerLayerTiles.global_transform
	
	
	#maybe the max should be different than this, but that's a later problem
	var collision_bodies:Array[Dictionary] = space_state.intersect_shape(query, playerLayerTiles.get_used_cells().size())
	
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


func _on_layer_choice_item_selected(index: int) -> void:
	
	if index == 0:
		curr_canvas = playerLayer
		curr_tile_layer = playerLayerTiles
	else:
		curr_canvas = fgLayers[0]
		curr_tile_layer = curr_canvas.get_node("TileMapLayer")
	
	
	pass # Replace with function body.
