extends Control

# ? - Duch
# ! - Burmistrz
var dialog_lines = [
	"?Zaraz, kto to... Pan Burmistrz?",
	"!Czołem, duszku. Niezły tu masz bałagan.",
	"?Ech, nic nowego. Czy mogę Panu pomóc?",
	"!Szukam Dziewicy Moru, czy widziałeś ją może?",
	"?Niestety nie...",
	"!Nie szkodzi, prędzej czy później ją znajdę.",
	"?Powodzenia, Burmistrzu.",
	"!Tobie również, duszku."
]
@onready var display_label = $NinePatchRect/TextLabel
@onready var texture_rect = $NinePatchRect/TextureRect
@onready var animation_player = $AnimationPlayer

# Przechowywanie aktualnej linii dialogu i indeksu litery
var current_line_index = 0
var current_char_index = 0
var is_text_scrolling = false
var full_line = ""
var typing_speed = 0.05  # Czas (w sekundach) między literami
var typing_active = false  # Flaga kontrolująca, czy animacja jest aktywna

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
		if full_line[0] == "?":
			animation_player.play("ghost_talk")
		elif full_line[0] == "!":
			animation_player.play("burgmaster_talk")
		full_line[0] = ""
		current_char_index = 0
		display_label.text = ""
		is_text_scrolling = true
		typing_active = true
		# Rozpoczynamy animację liter
		start_typing_text()

	else:
		get_parent().get_parent().after_dialog()
		queue_free()
		# Koniec dialogu, np. zamknij scenę dialogu
		#print("Koniec dialogów.")

# Funkcja stopniowo wyświetlająca tekst
func start_typing_text():
	# Wywołuje się co "typing_speed" sekund, aż wyświetli cały tekst
	if typing_active:
		await get_tree().create_timer(typing_speed).timeout
		if current_char_index < full_line.length() and typing_active:
			display_label.text += full_line[current_char_index]
			current_char_index += 1
			# Kontynuujemy wyświetlanie liter, jeśli jeszcze nie skończono
			start_typing_text()
		else:
			# Cała linia została wyświetlona
			is_text_scrolling = false
			typing_active = false
			#display_label.text = full_line
			current_line_index += 1

# Funkcja natychmiastowego wyświetlenia całego tekstu
func skip_text_animation():
	is_text_scrolling = false
	typing_active = false  # Przerywamy dalsze animowanie liter
	display_label.text = full_line

	# Zwiększ indeks dialogu na następny
	#current_line_index += 1
