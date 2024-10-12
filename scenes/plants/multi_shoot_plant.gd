extends "res://scenes/plant_base/plant_base.gd"

@export var projectile_scene: PackedScene
@export var projectile_count: int = 6

func shoot():
	if not available:
		return
	for i in range(projectile_count):
		var angle = deg_to_rad(360 - (i * 360/projectile_count))
		var projectile = projectile_scene.instantiate()
		add_sibling(projectile)
		projectile.global_position = global_position
		projectile.direction = Vector2(cos(angle), sin(angle))
		await get_tree().create_timer(.1).timeout

func _on_shooting_timer_timeout():
	shoot()
