extends Area2D

@export var health: int = 20
var max_health = health

signal base_destroyed

func _ready():
	max_health = health
	connect("base_destroyed", get_parent().get_parent().lose)

func _process(delta):
	#print(health)
	$CanvasLayer/VBoxContainer/ProgressBar.max_value = max_health
	$CanvasLayer/VBoxContainer/ProgressBar.value = health

func take_damage(damage):
	health = max(0, health - damage)
	if health == 0:
		base_destroyed.emit()
		queue_free()
	$Sprite2D.material.set_shader_parameter("active",true)
	await get_tree().create_timer(.1).timeout
	$Sprite2D.material.set_shader_parameter("active",false)
