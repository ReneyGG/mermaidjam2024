extends "res://scenes/plant_base/plant_base.gd"


func explode():
	for enemy in $ExplodeArea.get_overlapping_bodies():
		if enemy.is_in_group("enemy"):
			enemy.take_damage(2)
			var direction = global_position.direction_to(enemy.global_position)
			enemy.knockback(direction, 750)
	die()

func take_damage(damage):
	health = max(0, health - damage)
	if health == 0:
		explode()
