extends CanvasLayer

func _ready():
	$AnimationPlayer.play("fade_in")

func fade_in():
	$AnimationPlayer.play("fade_in")
	get_tree().paused = false

func fade_out(scene):
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(scene)
	fade_in()
	Pause.hide()
	Pause.clicked = false
