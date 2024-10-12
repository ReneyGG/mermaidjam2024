extends Node2D

@export var damage: int = 1

func _process(delta):
	$Sprite2D.modulate = get_parent().color

func _on_attack_area_body_entered(body):
	if not get_parent().available:
		return
	if body.is_in_group("enemy"):
		body.take_damage(damage)
		body.knockback(global_position.direction_to(body.global_position), 300)
