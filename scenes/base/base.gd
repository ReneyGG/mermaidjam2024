extends Sprite2D

@export var health: int = 10
var max_health = health

func _process(delta):
	$CanvasLayer/VBoxContainer/ProgressBar.max_value = max_health
	$CanvasLayer/VBoxContainer/ProgressBar.value = health

func take_damage(damage):
	health = max(0, health - damage)
	if health == 0:
		#print("BASE DESTROYED")
		queue_free()
