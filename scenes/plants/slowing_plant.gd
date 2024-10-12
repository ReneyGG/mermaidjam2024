extends "res://scenes/plant_base/plant_base.gd"


func _on_slowing_area_body_entered(body):
	if body.is_in_group("enemy"):
		body.speed /= 2


func _on_slowing_area_body_exited(body):
	if body.is_in_group("enemy"):
		body.speed *= 2
