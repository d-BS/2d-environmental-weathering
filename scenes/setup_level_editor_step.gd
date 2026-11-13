extends Control

@export_file_path() var tile_placement

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_load_scene_button_pressed() -> void:
	
	$LoadSceneButton/LoadSceneDialogue.show()
	
	pass # Replace with function body.



func _on_load_scene_dialogue_file_selected(path: String) -> void:
	
	Global.set_scene(path)
	
	pass # Replace with function body.



func _on_new_scene_button_pressed() -> void:
	
	Global.level_size.x = $LevelSizeX.value
	Global.level_size.y = $LevelSizeY.value
	
	Global.set_scene(tile_placement)
	
	pass # Replace with function body.
