extends "res://scenes/plant_base/plant_base.gd"

func take_damage(damage):
	health = max(0, health - damage)
	if health == 0:
		for enemy in $AggroArea.get_overlapping_bodies():
			if enemy.is_in_group("enemy"):
				enemy.target = get_tree().get_first_node_in_group("base")
		queue_free()

func _on_aggro_area_body_entered(body):
	if body.is_in_group("enemy"):
		body.target = self
		print(body)

func _on_aggro_area_body_exited(body):
	if body.is_in_group("enemy"):
		body.target = get_tree().get_first_node_in_group("base")
		print(body)
