extends Node2D

const width = 500
const height = 500

@onready var noise_demo = $Sprite2D

func _process(delta):
	randomize()
	#var fnl = FastNoiseLite.new()
	#fnl.seed = randi_range(0,500)
	#fnl.noise_type = noise.noise_type
	#fnl.fractal_octaves = 1
	#fnl.fractal_type = FastNoiseLite.FRACTAL_RIDGED
	#fnl.frequency = 0.05
	
	for x in range(width):
		for y in range(height):
			var noise = floor(abs(noise_demo.texture.noise.get_noise_2d(x,y)*2))
			if noise == 0:
				$TileMapLayer.set_cell(Vector2i(x,y), 0, Vector2(0,0))
			else:
				$TileMapLayer.erase_cell(Vector2i(x,y))
