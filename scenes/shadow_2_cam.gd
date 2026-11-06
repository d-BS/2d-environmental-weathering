@tool
extends Node2D

@export var camera:Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#$Foreground.set_instance_shader_parameter("layer", .5)
	#$Midground.set_instance_shader_parameter("layer", 1)
	#$Background.set_instance_shader_parameter("layer", 2)
	
	
	
	$Background.set_instance_shader_parameter("scale", $Background.scale)
	$Foreground.set_instance_shader_parameter("scale", $Foreground.scale)
	$Midground.set_instance_shader_parameter("scale", $Midground.scale)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	RenderingServer.global_shader_parameter_set("camera_position", camera.position)
	
	pass
