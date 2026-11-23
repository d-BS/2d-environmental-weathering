extends AnimatableBody2D

@export var start_pos:Vector2
@export var end_pos:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func activate():
	
	
	$AnimationPlayer.play("platform_animation")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play_backwards("platform_animation")
	
	
