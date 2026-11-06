extends Camera2D


var camera_speed:float = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	if Input.is_action_pressed("S"):
		
		position.y += camera_speed * delta
		
	if Input.is_action_pressed("W"):
		
		position.y -= camera_speed * delta
		
	if Input.is_action_pressed("A"):
		
		position.x -= camera_speed * delta
		
	if Input.is_action_pressed("D"):
		
		position.x += camera_speed * delta
	
	
	pass
