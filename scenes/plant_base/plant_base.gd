extends Node2D

@export var type : String
@export var health : int = 5
@export var color : Color
@export var selected := false

@export var current_health = health

func _ready():
	$ProgressBar.max_value = health
	$Sprite2D.modulate = color

func _process(delta):
	#print(name, ": ", current_health)
	$ProgressBar.value = current_health

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
	hide
	
func take_damage(damage):
	current_health = max(0, current_health - damage)
	if current_health == 0:
		queue_free()
		
func take_heal(heal):
	current_health = min(health, current_health + heal)
