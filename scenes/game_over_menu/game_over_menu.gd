extends Control

var time_to_print = "00:00:00"
var ponits_to_print = 0
@onready var time_label = $ColorRect/VBoxContainer/TimeLabel
@onready var pointslabel = $ColorRect/VBoxContainer/Pointslabel


# Called when the node enters the scene tree for the first time.
func update():
	time_label.text = "Czas: " + time_to_print
	pointslabel.text = "Punkty: " + str(ponits_to_print)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_restart_button_pressed():
	Fade.fade_out("res://scenes/level/level.tscn")


func _on_menu_button_pressed():
	Fade.fade_out("res://scenes/main_menu/main_menu.tscn")
