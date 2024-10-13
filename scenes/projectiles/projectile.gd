extends Node2D

@export var speed: float = 200
@export var damage: int = 1
var direction

#func _ready():
	#GlobalSound.play_sound("res://assets/audio/Pocisk.mp3")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if direction:
		rotation += delta * 2
		global_position += direction * speed * delta


func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		body.take_damage(damage)
		queue_free()
