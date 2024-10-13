extends Control

# ? - Duch
# ! - Burmistrz
var burmistrz_1 = [
	"?Zaraz, kto to... Pan Burmistrz?",
	"!Czołem, duszku. Niezły tu masz bałagan.",
	"?Ech, nic nowego. Czy mogę Panu pomóc?",
	"!Szukam Dziewicy Moru, czy widziałeś ją może?",
	"?Niestety nie...",
	"!Nie szkodzi, prędzej czy później ją znajdę.",
	"?Powodzenia, Burmistrzu.",
	"!Tobie również, duszku."
]

var burmistrz_2 = [
	"?Panie Burmistrzu, Pan był aptekarzem, prawda?",
	"!W rzeczy samej, duszku.",
	"?Czy ma Pan dla mnie jakiś lek, żeby być silniejszym?",
	"!No tak, głupi ja.",
	"?Rozchmurz się, sukces przychodzi trudniej tym, któym brakuje pogody ducha"
]

var baba_1 = [
	"!Powróciłeś, mały stróżu.",
	"?Tak, niestety zawiodłem, ogród jest w ruinach...",
	"!Nie szkodzi, twoje starania nie poszły na marne.",
	"?Jak to? Chyba każdy kwiat w ogrodach został zdeptany.",
	"!Kwiaty odrosną, nie trać wiary."
]

var baba_2 = [
	"?Starościno...",
	"!Widzę, że wróciłeś, mały stróżu.",
	"?Niestety, znowu byłem za słaby.",
	"!Nic dziwnego, twój wróg miał znaczną przewagę.",
	"?Czy jeden mały duch ma jakiekolwiek szanse w tej walce?",
	"!Ma, w końcu się uda, mały stróżu."
]

var krol_1 = [
	"?Znowu obcy? ",
	"!Żaden obcy, zjawo. Tak mówisz do Króla?",
	"?Dworska etykieta nie jest moją mocną stroną...",
	"!Następnym razem przywitaj się jak na męzczyznę przystało.",
	"?Ale ja...",
	"!Czas na mnie. Miej się na baczności, zjawo."
]


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
var random_dialog = null

@export var can_click: bool = false

func _ready():
	random_dialog = [burmistrz_1, burmistrz_2, baba_1, baba_2, krol_1].pick_random()
	match random_dialog:
		burmistrz_1, burmistrz_2:
			burgmaster.texture = load("res://assets/characters/burmistrz.png")
		baba_1, baba_2:
			burgmaster.texture = load("res://assets/characters/baba.png")
		krol_1:
			burgmaster.texture = load("res://assets/characters/krol.png")

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
	if current_line_index < random_dialog.size():
		full_line = random_dialog[current_line_index]
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
