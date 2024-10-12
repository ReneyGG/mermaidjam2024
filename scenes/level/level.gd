extends Node2D

var score = 0
var elapsed_time: float = 0.0
	
func update_score(score_amount):
	score += score_amount
	print(score)

func format_time(seconds: float) -> String:
	var minutes = int(seconds) / 60
	var remaining_seconds = int(seconds) % 60
	var centiseconds = int((seconds - int(seconds)) * 100)
	
	return str(minutes).pad_zeros(2) + ":" + str(remaining_seconds).pad_zeros(2) + ":" + str(centiseconds).pad_zeros(2)
