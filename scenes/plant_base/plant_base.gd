extends Node2D

@export var type : String
@export var health : int = 5
@export var color : Color
@export var selected := false
@export var adopted_children : Array

var adopted := false
var parent

@export var available := true

@export var current_health = health

func _ready():
	randomize()
	$ProgressBar.max_value = health
	$Sprite2D.modulate = color
	$Sprite2D.frame = randi_range(0,3)
	$Sprite2D.play("default")
	$Aurora.hide()
	$RangeHint.hide()

func _physics_process(_delta):
	if parent and adopted:
		self.global_position = parent.global_position

func _process(delta):
	#print(name, ": ", current_health)
	$ProgressBar.value = current_health

func change_color(c):
	color = c
	$Sprite2D.modulate = c

func switch_select(on):
	selected = on
	if selected:
		#get_node("Sprite2D").material.set_shader_parameter("width", 6.0)
		$Aurora.show()
	else:
		#get_node("Sprite2D").material.set_shader_parameter("width", 0.0)
		$Aurora.hide()

func adopt_by(new_parent):
	adopted = true
	parent = new_parent

func pick():
	$CollisionShape2D.disabled = true
 
func drop():
	$CollisionShape2D.disabled = false

func harvest():
	available = false
	$CollisionShape2D.disabled = true
	hide()
	
func take_damage(damage):
	current_health = max(0, current_health - damage)
	if current_health == 0:
		die()
		
func take_heal(heal):
	#if health == current_health:
		#return
	current_health = min(health, current_health + heal)
	$HealEffect.visible = true
	$HealEffect.play("default")
	await $HealEffect.animation_finished
	$HealEffect.visible = false

#gdzie są te dzieci
func die():
	get_to_parent()

func get_to_parent():
	if parent:
		parent.get_to_parent()
	else:
		kill_children()

func kill_children():
	if type == "explosive":
		explode()
	for i in adopted_children:
		i.adopted = false
		i.kill_children()
	queue_free()

func explode():
	var explode_effect = load("res://scenes/effects/explosion_effect.tscn").instantiate()
	add_sibling(explode_effect)
	explode_effect.global_position = global_position
	explode_effect.emitting = true
	for enemy in $ExplodeArea.get_overlapping_bodies():
		if enemy.is_in_group("enemy"):
			enemy.take_damage(2)
			var direction = global_position.direction_to(enemy.global_position)
			enemy.knockback(direction, 750)

func _on_mouse_entered():
	$RangeHint.show()

func _on_mouse_exited():
	$RangeHint.hide()
