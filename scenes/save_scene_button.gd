extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _pressed() -> void:
	
	$SaveSceneDialogue.show()
	pass



func _on_save_scene_dialogue_file_selected(path: String) -> void:
	
	var scene_to_save:PackedScene = PackedScene.new()
	scene_to_save.pack(Global.current_scene)
	
	ResourceSaver.save(scene_to_save, path)
	
	pass # Replace with function body.
