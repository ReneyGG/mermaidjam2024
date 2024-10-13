extends Node


func play_sound(sound):
	var sound_player = AudioStreamPlayer.new()
	sound_player.stream = load(sound)
	sound_player.volume_db = -10
	if sound == "res://assets/audio/Death.mp3":
		sound_player.pitch_scale = randf_range(.3, .6)
	else:
		sound_player.pitch_scale = randf_range(.8, 1)
	add_child(sound_player)
	sound_player.play()
	await sound_player.finished
	sound_player.queue_free()
