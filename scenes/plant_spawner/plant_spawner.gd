extends Node2D

const WIDTH = 2500
const HEIGHT = 1500

var plant_limit = INF
#var plants = [preload("res://scenes/plants/shooting_flower.tscn"),
#preload("res://scenes/plants/aggro_plant.tscn"),
#preload("res://scenes/plants/explosive_plant.tscn"),
#preload("res://scenes/plants/slowing_plant.tscn")]

var plants = [preload("res://scenes/plants/blue_plant.tscn"),
preload("res://scenes/plants/red_plant.tscn")]

func _on_spawn_timer_timeout():
	if get_tree().get_node_count_in_group("plant") > plant_limit:
		return
	var random_position = Vector2(randf_range(-1750, 1750), randf_range(-900, 900))
	var random_plant = plants.pick_random()
	var plant_inst = random_plant.instantiate()
	add_sibling(plant_inst)
	plant_inst.global_position = random_position
