extends Node2D

@export var type : String
@export var health : int = 5
@export var color : Color

@export var selected := false

func _ready():
	$Sprite2D.modulate = color

func switch_select():
	if selected:
		selected = false
		get_node("Sprite2D").material.set_shader_parameter("width", 0.0)
	else:
		selected = true
		get_node("Sprite2D").material.set_shader_parameter("width", 4.0)

func pick():
	$CollisionShape2D.disabled = true
	pass
 
func drop():
	$CollisionShape2D.disabled = false
	pass

func harvest():
	queue_free()
	
func take_damage(damage):
	health = max(0, health - damage)
	if health == 0:
		queue_free()
