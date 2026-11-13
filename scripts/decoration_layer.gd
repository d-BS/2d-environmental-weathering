@tool
extends CanvasLayer


@export var distance:float = 1:
	set(value):
		if value < 0:
			value = 0
		distance = value
		follow_viewport_scale = 1 / value
		follow_viewport_enabled = true


func ready():
	
	follow_viewport_scale = 1 / distance
	
	follow_viewport_enabled = true
	pass
