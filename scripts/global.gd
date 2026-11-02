extends Node

var current_scene:Node = null

## Images which we pass between scenes
var passed_image:Array[Image] = []

var pLayer_collision_polys:Array[PackedVector2Array] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	current_scene = get_tree().root.get_child(-1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


## changes the scene to the given path
func set_scene(path:String):
	current_scene.queue_free()
	_deferred_set_scene.call_deferred(path)
	
	
func _deferred_set_scene(path:String):

	var new_scene:PackedScene = ResourceLoader.load(path)
	
	current_scene = new_scene.instantiate()
	get_tree().root.add_child(current_scene)
