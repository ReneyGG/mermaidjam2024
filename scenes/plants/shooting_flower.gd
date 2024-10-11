extends "res://scenes/plant_base/plant_base.gd"

@export var projectile_scene: PackedScene
var target

func shoot():
	if !target:
		return
	var direction = global_position.direction_to(target.global_position)
	var projectile = projectile_scene.instantiate()
	projectile.direction = direction
	add_sibling(projectile)
	projectile.global_position = global_position

func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy") and !target:
		target = body
		#shoot(global_position.direction_to(body.global_position))


func _on_area_2d_body_exited(body):
	if body == target:
		target = null
		#target = $Area2D.get_overlapping_bodies()[0]
