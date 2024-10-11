extends Node2D

@export var enemy_scene: PackedScene


func spawn_enemies():
	var group_spawn_position = pick_random_position(global_position, 700)
	for i in range(1):
		var enemy = enemy_scene.instantiate()
		get_parent().add_child(enemy)
		enemy.global_position = pick_random_position(group_spawn_position, 100)


func pick_random_position(center, distance):	
	# Losujemy kąt w radianach (od 0 do 2 * PI)
	var angle = randf() * TAU  # TAU to 2 * PI
	
	# Obliczamy przesunięcie na podstawie kąta i odległości
	var offset_x = cos(angle) * distance
	var offset_y = sin(angle) * distance
	
	# Wyznaczamy nową pozycję na podstawie środka i przesunięcia
	var new_position = center + Vector2(offset_x, offset_y)
	
	# Wyświetlamy pozycję
	print("Nowa pozycja: ", new_position)
	return new_position
