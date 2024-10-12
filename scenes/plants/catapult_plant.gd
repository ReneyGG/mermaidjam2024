extends "res://scenes/plant_base/plant_base.gd"

@export var projectile_scene: PackedScene

var target

func shoot(target_position):
	var projectile = projectile_scene.instantiate()
	add_sibling(projectile)
	var direction = global_position.direction_to(target_position)
	var desired_distance = global_position.distance_to(target_position)
	var desired_angle_deg = 45
	projectile.LaunchProjectile(global_position, direction, desired_distance, desired_angle_deg)


func _on_shooting_timer_timeout():
	var others = $RangeArea.get_overlapping_bodies()
	others.erase(get_tree().get_first_node_in_group("player"))
	if others:
		target = others.pick_random()
		shoot(target.global_position)
