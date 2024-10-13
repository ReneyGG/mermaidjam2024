extends Control

var clicked := false

func _ready():
	pass

func _on_play_button_pressed():
	if not clicked:
		clicked = true
		Fade.fade_out("res://scenes/level/level.tscn")

func _on_quit_button_pressed():
	if not clicked:
		clicked = true
		get_tree().quit()
