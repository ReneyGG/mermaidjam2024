extends Node2D

@onready var game_over_menu = $Interface/GameOverMenu
@onready var score_label = $Interface/Score/ScoreLabel

var score = 0
var elapsed_time: float = 0.0
	
func _ready():
	await get_tree().create_timer(1).timeout
	get_tree().paused = true
	$Interface.add_child(load("res://scenes/visual_novel/tutorial_dialog.tscn").instantiate())
	
func _process(delta):
	elapsed_time += delta
	
func update_score(score_amount):
	score += score_amount
	score_label.text = "Punkty: " + str(score)
	$Interface/Score/AnimationPlayer.play("new_score")

func format_time(seconds: float) -> String:
	var minutes = int(seconds) / 60
	var remaining_seconds = int(seconds) % 60
	var centiseconds = int((seconds - int(seconds)) * 100)
	
	return str(minutes).pad_zeros(2) + ":" + str(remaining_seconds).pad_zeros(2) + ":" + str(centiseconds).pad_zeros(2)

func lose():
	get_tree().paused = true
	GlobalSound.play_sound("res://assets/audio/Poraĺka .mp3")
	$Interface.add_child(load("res://scenes/visual_novel/visual_novel.tscn").instantiate())
	
func after_dialog():
	game_over_menu.time_to_print = format_time(elapsed_time)
	game_over_menu.ponits_to_print = score
	game_over_menu.update()
	game_over_menu.visible = true
	$Interface/Score.visible = false
