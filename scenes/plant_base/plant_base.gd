extends Node2D

@export var texture : Texture
@export var health : int = 5

func _ready():
	$Sprite2D.texture = texture

func pick():
	$CollisionShape2D.disabled = true
	pass

func drop():
	$CollisionShape2D.disabled = false
	pass

func harvest():
	queue_free()
	
func take_damage(damage):
	print("taken damage: ", damage)
	health = max(0, health - damage)
	if health == 0:
		queue_free()
