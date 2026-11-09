#@tool
extends Node2D

@export var camera:Camera2D
@export var subviewport:SubViewport

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#$Foreground.set_instance_shader_parameter("layer", .5)
	#$Midground.set_instance_shader_parameter("layer", 1)
	#$Background.set_instance_shader_parameter("layer", 2)
	
	$Background.material.set_shader_parameter("shadowtex", subviewport.get_texture())
	
	$Background.set_instance_shader_parameter("scale", $Background.scale)
	$Foreground.set_instance_shader_parameter("scale", $Foreground.scale)
	$Midground.set_instance_shader_parameter("scale", $Midground.scale)
	
	subviewport.world_2d = get_viewport().find_world_2d()
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	RenderingServer.global_shader_parameter_set("camera_position", Vector3(camera.position.x, camera.position.y, 1/camera.zoom.x))
	RenderingServer.global_shader_parameter_set("light_pos", Vector3(50, -100, 1))#Vector3(-camera.position.x, -camera.position.y, 1/camera.zoom.x))
	
	pass
