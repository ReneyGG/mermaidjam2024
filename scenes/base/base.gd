extends Area2D

@export var health: int = 10
var max_health = health

func _process(delta):
	$CanvasLayer/VBoxContainer/ProgressBar.max_value = max_health
	$CanvasLayer/VBoxContainer/ProgressBar.value = health

func take_damage(damage):
	health = max(0, health - damage)
	if health == 0:
		queue_free()
	$Sprite2D.material.set_shader_parameter("active",true)
	await get_tree().create_timer(.1).timeout
	$Sprite2D.material.set_shader_parameter("active",false)
