extends "res://scenes/plant_base/plant_base.gd"

@export var projectile_scene: PackedScene
var target

func shoot():
	var others = $Area2D.get_overlapping_bodies()
	others.erase(get_tree().get_first_node_in_group("player"))
	target = get_nearest_node(others)
	if !target:
		return
	var direction = global_position.direction_to(target.global_position)
	var projectile = projectile_scene.instantiate()
	projectile.direction = direction
	add_sibling(projectile)
	projectile.global_position = global_position

#func _on_area_2d_body_entered(body):
	#if body.is_in_group("enemy") and !target:
		#target = body
		##shoot(global_position.direction_to(body.global_position))
#
#
#func _on_area_2d_body_exited(body):
	#if body == target:
		#var other_enemies = $Area2D.get_overlapping_bodies()
		#other_enemies.erase(get_tree().get_first_node_in_group("player"))
		#if other_enemies:
			#target = other_enemies[0]
		#else:
			#target = null
		#print(other_enemies)
func get_nearest_node(nodes: Array) -> Node2D:
	var nearest_node: Node2D = null
	var shortest_distance: float = INF  # Zaczynamy od bardzo dużej wartości (nieskończoności)

	for node in nodes:
		# Obliczamy odległość między daną pozycją a pozycją aktualnego węzła
		var distance = node.global_position.distance_to(global_position)

		# Jeśli odległość jest krótsza niż dotychczasowa najmniejsza odległość, zapisujemy ten węzeł
		if distance < shortest_distance:
			shortest_distance = distance
			nearest_node = node
	
	return nearest_node
