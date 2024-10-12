extends "res://scenes/plant_base/plant_base.gd"

@onready var healing_area = $HealingArea

func _on_heal_timer_timeout():
	if not available:
		return
	print("av")
	for plant in healing_area.get_overlapping_areas():
		if plant.is_in_group("plant") and plant != self:
			plant.take_heal(1)
			#var heal_line = Line2D.new()
			#add_sibling(heal_line)
			#heal_line.set_points([Vector2(global_position), plant.global_position])
			#heal_line.texture = load("res://icon.svg")
			
