extends Control

@export var dialog_lines: Array[String] = []
@onready var display_label = $NinePatchRect/TextLabel


# Przechowywanie aktualnej linii dialogu i indeksu litery
var current_line_index = 0
var current_char_index = 0
var is_text_scrolling = false
var full_line = ""
var typing_speed = 0.05  # Czas (w sekundach) między literami

func _ready():
	show_next_line()

func _process(delta):
	# Sprawdzenie kliknięcia w trakcie wyświetlania tekstu
	if Input.is_action_just_pressed("pick"):
		if is_text_scrolling:
			# Jeśli tekst jest w trakcie przewijania, wyświetl go od razu
			skip_text_animation()
		else:
			# Jeśli tekst został w pełni wyświetlony, przejdź do następnej linii
			show_next_line()

# Funkcja do wyświetlenia kolejnej linii dialogu
func show_next_line():
	if current_line_index < dialog_lines.size():
		full_line = dialog_lines[current_line_index]
		current_char_index = 0
		display_label.text = ""
		is_text_scrolling = true
		# Rozpoczynamy animację liter
		start_typing_text()
	else:
		# Koniec dialogu, np. zamknij scenę dialogu
		print("Koniec dialogów.")

# Funkcja stopniowo wyświetlająca tekst
func start_typing_text():
	# Wywołuje się co "typing_speed" sekund, aż wyświetli cały tekst
	await get_tree().create_timer(typing_speed).timeout
	if current_char_index < full_line.length():
		display_label.text += full_line[current_char_index]
		current_char_index += 1
		# Wywołujemy ponownie do wyświetlenia kolejnej litery
		start_typing_text()
	else:
		# Cała linia została wyświetlona
		is_text_scrolling = false
		current_line_index += 1
		print("test")

# Funkcja natychmiastowego wyświetlenia całego tekstu
func skip_text_animation():
	is_text_scrolling = false
	display_label.text = full_line

	# Zwiększ indeks dialogu na następny
	current_line_index += 1
