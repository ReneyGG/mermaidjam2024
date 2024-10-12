extends "res://scenes/plant_base/plant_base.gd"

@onready var healing_area = $HealingArea

func _on_heal_timer_timeout():
	for plant in healing_area.get_overlapping_areas():
		if plant.is_in_group("plant"):
			plant.take_heal(1)
