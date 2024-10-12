extends "res://scenes/plant_base/plant_base.gd"


func _on_healing_area_area_entered(area):
	if area.is_in_group("plant"):
		print(area)
