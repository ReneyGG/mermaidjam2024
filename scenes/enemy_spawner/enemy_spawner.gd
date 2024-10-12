extends Node2D

@export var enemy_scene: PackedScene

var enemies = {
	"res://scenes/enemy/enemy.tscn": 80,
	"res://scenes/enemy/enemy_big.tscn": 80
}

func spawn_enemies():
	var group_spawn_position = pick_random_position(global_position, 700)
	for i in range(3):
		var enemy = load(weighted_random_choice(enemies)).instantiate()
		#var new_scale = randf_range(1, 2)
		#var new_speed = enemy.speed / new_scale
		enemy.global_position = pick_random_position(group_spawn_position, 100)
		#enemy.scale = Vector2(new_scale, new_scale)
		#enemy.speed = new_speed
		#enemy.health += int(new_scale * 5)
		add_sibling(enemy)
		


func pick_random_position(center, distance):	
	# Losujemy kąt w radianach (od 0 do 2 * PI)
	var angle = randf() * TAU  # TAU to 2 * PI
	
	# Obliczamy przesunięcie na podstawie kąta i odległości
	var offset_x = cos(angle) * distance
	var offset_y = sin(angle) * distance
	
	# Wyznaczamy nową pozycję na podstawie środka i przesunięcia
	var new_position = center + Vector2(offset_x, offset_y)
	
	return new_position


func weighted_random_choice(weights: Dictionary) -> String:
	# Obliczamy całkowitą sumę wag
	var total_weight = 0.0
	for value in weights.values():
		total_weight += value

	# Losujemy liczbę z zakresu od 0 do total_weight
	var random_value = randf() * total_weight

	# Iterujemy przez słownik, aby znaleźć pasujący element
	var cumulative_weight = 0.0
	for key in weights.keys():
		cumulative_weight += weights[key]
		if random_value <= cumulative_weight:
			return key  # Zwracamy element, który odpowiada wylosowanej wartości

	# Wartość awaryjna (w przypadku, gdyby nic nie zostało zwrócone, co teoretycznie nie powinno się zdarzyć)
	return weights.keys()[0]
