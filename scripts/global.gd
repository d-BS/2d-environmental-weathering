extends Node

var current_scene:Node = null
var new_scene:PackedScene = preload("res://scenes/sample_level_scene.tscn")
var parallax_mat:ShaderMaterial = preload("res://assets/parallax_material.tres")

## Images which we pass between scenes
var passed_image:Array[Image] = []
var level_size:Vector2i = Vector2i(640 * 2, 360)

var pLayer_collision_polys:Array[PackedVector2Array] = []

var shadow_cast:PackedFloat32Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	current_scene = get_tree().root.get_child(-1)
	
	# this is 640 x 360
	shadow_cast.resize(230400)
	shadow_cast.fill(0)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("R"):
		_deferred_reset_scene.call_deferred()
	

## changes the scene to the given path
func set_scene(path:String):
	current_scene.queue_free()
	_deferred_set_scene.call_deferred(path)
	
	
func _deferred_set_scene(path:String):

	new_scene = ResourceLoader.load(path)
	
	current_scene = new_scene.instantiate()
	get_tree().root.add_child(current_scene)

func _deferred_reset_scene():
	current_scene.queue_free()
	current_scene = new_scene.instantiate()
	get_tree().root.add_child(current_scene)
