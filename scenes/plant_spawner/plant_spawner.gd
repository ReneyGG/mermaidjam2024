extends Node2D

const WIDTH = 2500
const HEIGHT = 1500

var plants = [preload("res://scenes/plants/shooting_flower.tscn")]

func _on_spawn_timer_timeout():
	var random_position = Vector2(randf_range(0, WIDTH), randf_range(0, HEIGHT))
	var random_plant = plants.pick_random()
	var plant_inst = random_plant.instantiate()
	add_sibling(plant_inst)
	plant_inst.global_position = random_position
