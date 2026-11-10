#@tool
extends Node2D

@export var camera:Camera2D
@export var subviewport:SubViewport

var light_pos:Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#$Foreground.set_instance_shader_parameter("layer", .5)
	#$Midground.set_instance_shader_parameter("layer", 1)
	#$Background.set_instance_shader_parameter("layer", 2)
	
	subviewport.get_node("Camera2D").zoom = Vector2(1.000001, 1.00000)
	
	$Background.material.set_shader_parameter("shadowtex", subviewport.get_texture())
	
	$Background.set_instance_shader_parameter("scale", $Background.scale)
	$Foreground.set_instance_shader_parameter("scale", $Foreground.scale)
	$Midground.set_instance_shader_parameter("scale", $Midground.scale)
	$StaticBody2D/ground.set_instance_shader_parameter("scale", $StaticBody2D/ground.scale)
	subviewport.world_2d = get_viewport().find_world_2d()
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	RenderingServer.global_shader_parameter_set("camera_position", Vector3(camera.position.x, camera.position.y, 0))
	RenderingServer.global_shader_parameter_set("light_pos", light_pos)#Vector3(camera.position.x, camera.position.y, 0))
	
	subviewport.get_node("Camera2D").position = $Camera2D.position - Vector2(640, 360) / 2
	
	pass




func _on_v_slider_value_changed(value: float) -> void:
	
	light_pos.y = value
	
	pass # Replace with function body.


func _on_h_slider_value_changed(value: float) -> void:
	
	light_pos.x = value
	
	pass # Replace with function body.


func _on_d_slider_value_changed(value: float) -> void:
	
	light_pos.z = value
	
	pass # Replace with function body.
