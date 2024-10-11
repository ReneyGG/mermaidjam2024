extends Node2D

@export var speed: float = 200
var direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if direction:
		global_position += direction * speed * delta
