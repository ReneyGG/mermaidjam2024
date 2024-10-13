extends Control

# ? - Duch
# ! - Burmistrz

@onready var display_label = $NinePatchRect/TextLabel
#@onready var texture_rect = $NinePatchRect/TextureRect
@onready var animation_player = $AnimationPlayer
@onready var burgmaster = $burgmaster

# Przechowywanie aktualnej linii dialogu i indeksu litery
var current_line_index = 0
var current_char_index = 0
var is_text_scrolling = false
var full_line = ""
var typing_speed = 0.05  # Czas (w sekundach) między literami
var typing_active = false  # Flaga kontrolująca, czy animacja jest aktywna
var current_dialog = [
	"?Starościno! Do ogrodów wdarli się intruzi!",
	"!A więc pora stawić im czoła, mały stróżu.",
	"?Ale jak? Jestem tylko duszkiem, nie mam jak ich zatrzymać.",
	"!Zdziwisz się ile masz możliwości, mały stróżu.",
	"!Widzisz te barwne kwiaty? Są równie skore do walki co ty, ale potrzebują twojej pomocy.",
	"!Podejdź do jednego i kliknij [LPM] żeby go podnieść.",
	"!Nawet będąc w doniczce kwiat nie przestanie atakować napastników.",
	"!Kliknij ponownie [LPM] żeby przesadzić go w inne miejsce.",
	"!Znajdujac kwiat mozesz zebrać jego nasiona [PPM].",
	"!Jeśli znajdziesz dwa, wnet wyrośnie nowy kwiat, gotowy do posadzenia.",
	"!Każdy kwiat ma swojego ulubieńca, kiedy współpracują znacznie rosną w siłę.",
	"!Kiedy odkryjesz nową parę, będziesz mógł ją podejrzeć w encyklopedii, nie zgubiłeś jej, prawda?",
	"?Skądże! Mam ją tutaj, pod [Esc]",
	"!Dobrze, zaglądaj do niej jeśli potrzebujesz sobie odświeżyć pamięć.",
	"!Czas na ciebie, mały stróżu, powodzenia!"
]

@export var can_click: bool = false

func _process(delta):
	# Sprawdzenie kliknięcia w trakcie wyświetlania tekstu
	if Input.is_action_just_pressed("pick") and can_click:
		if is_text_scrolling:
			# Jeśli tekst jest w trakcie przewijania, wyświetl go od razu
			skip_text_animation()
		else:
			# Jeśli tekst został w pełni wyświetlony, przejdź do następnej linii
			show_next_line()

# Funkcja do wyświetlenia kolejnej linii dialogu
func show_next_line():
	if current_line_index < current_dialog.size():
		full_line = current_dialog[current_line_index]
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
		get_tree().paused = false
		animation_player.play("popout")
		#queue_free()
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


func _on_texture_button_pressed():
	get_tree().paused = false
	animation_player.play("popout")
