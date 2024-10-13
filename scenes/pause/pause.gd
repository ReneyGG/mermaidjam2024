extends CanvasLayer

var clicked := false

func _ready():
	$Control/EncLeft.hide()
	$Control/EncRight.show()
	hide()

func _input(event):
	if event.is_action_released("pause") and not clicked:
		if visible:
			get_tree().paused = false
			hide()
		else:
			get_tree().paused = true
			show()

func _on_resume_button_pressed():
	hide()
	get_tree().paused = false
	clicked = false

func _on_menu_button_pressed():
	if not clicked:
		clicked = true
		Fade.fade_out("res://scenes/main_menu/main_menu.tscn")

func _on_enc_right_pressed():
	$Control/EncRight.hide()
	$Control/EncLeft.show()
	$Control/TextureRectR.hide()

func _on_enc_left_pressed():
	$Control/EncRight.show()
	$Control/EncLeft.hide()
	$Control/TextureRectR.show()
