extends Node2D

var dragging:bool = false
var selectionRect:Rect2

signal box_made(box:Rect2i)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	selectionRect = Rect2(0, 0, 0, 0)
	
	pass # Replace with function body.



func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("click"):
		
		dragging = true
		
		
	elif event.is_action_released("click"):
		
		
		_finalize_selection_gpu()
		
		selectionRect = Rect2(0, 0, 0, 0)
		dragging = false
		queue_redraw()
		
	
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	
		#coll_shape.shape.size = Vector2.ZERO
		
	
	if !dragging:
		position = get_global_mouse_position()
		
	else:
		
		selectionRect.position = position
		selectionRect.size = get_global_mouse_position() - position
		#selectionRect = selectionRect.abs()
		
		queue_redraw()
		
		
		pass
	
	pass





func _draw() -> void:
	
	var drawRect:Rect2 = selectionRect
	drawRect.position = Vector2.ZERO
	
	
	
	draw_rect(drawRect.abs(), Color(0.333, 0.624, 1.0, 0.75), true)
	




func _finalize_selection_gpu():
	
	selectionRect = selectionRect.abs()
	
	box_made.emit(Rect2i(selectionRect))
	
	pass
