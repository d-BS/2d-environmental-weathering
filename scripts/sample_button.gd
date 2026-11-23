extends AnimatableBody2D

@export var to_activate:Node

var being_pressed:bool = false
var pressers:Array[Node2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$Sprite2D.set_instance_shader_parameter("scale", $Sprite2D.scale)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	
	pass



func _on_area_2d_body_entered(body: Node2D) -> void:
	
	#if !can_press.has(body):
	#	return
	
	if body.global_position.y < global_position.y:
		
		if !being_pressed:
			if $AnimationPlayer.current_animation == "":
				$AnimationPlayer.play("pressed")
			else:
				$AnimationPlayer.play_section("pressed", $AnimationPlayer.current_animation_position, $AnimationPlayer.current_animation_length)
		
		being_pressed = true
		pressers.append(body)
	
	
	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	
	#if !can_press.has(body):
#		return
	
	var to_remove = pressers.find(body)
	
	if to_remove != -1:
		
		pressers.remove_at(to_remove)
		being_pressed = !pressers.is_empty()
		
		if !being_pressed:
			$AnimationPlayer.play_section_backwards("pressed", 0, $AnimationPlayer.current_animation_position)
		
	
	pass # Replace with function body.




func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	
	if being_pressed:
		
		#do stuff
		if to_activate.has_method("activate"):
			to_activate.activate()
		
		pass
	
	pass # Replace with function body.
