extends "res://scenes/plant_base/plant_base.gd"


func explode():
	for enemy in $ExplodeArea.get_overlapping_bodies():
		if enemy.is_in_group("enemy"):
			var direction = global_position.direction_to(enemy.global_position)
			enemy.knockback(direction, 750)
	queue_free()

func take_damage(damage):
	health = max(0, health - damage)
	if health == 0:
		explode()
