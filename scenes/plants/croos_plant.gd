extends "res://scenes/plant_base/plant_base.gd"

@export var projectile_scene: PackedScene
var projectile_count: int = 4

func shoot():
	if not available:
		return
	for i in range(projectile_count):
		var angle = deg_to_rad(360 - (i * 360/projectile_count))
		var projectile = projectile_scene.instantiate()
		add_sibling(projectile)
		projectile.global_position = global_position
		projectile.direction = Vector2(cos(angle), sin(angle))

func _on_shoot_timer_timeout():
	shoot()
