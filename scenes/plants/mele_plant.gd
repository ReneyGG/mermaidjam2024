extends "res://scenes/plant_base/plant_base.gd"

@onready var bee = $Bee
@export var bee_speed: int = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bee.rotation -= delta * bee_speed
