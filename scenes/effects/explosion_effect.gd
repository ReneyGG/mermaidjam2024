extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSound.play_sound("res://assets/audio/Wybuch.mp3")



func _on_finished():
	queue_free()
