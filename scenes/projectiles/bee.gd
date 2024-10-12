extends Node2D

@export var damage: int = 1

func _on_attack_area_body_entered(body):
	if body.is_in_group("enemy"):
		body.take_damage(damage)
		body.knockback(global_position.direction_to(body.global_position), 300)
