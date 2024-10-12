extends Node2D

@export var type : String
@export var health : int = 5
@export var color : Color
@export var selected := false
@export var adopted_children : Array

var adopted := false
var parent

@export var current_health = health

func _ready():
	$ProgressBar.max_value = health
	$Sprite2D.modulate = color

func _physics_process(_delta):
	if parent and adopted:
		self.global_position = parent.global_position

func _process(delta):
	#print(name, ": ", current_health)
	$ProgressBar.value = current_health

func switch_select():
	if selected:
		selected = false
		get_node("Sprite2D").material.set_shader_parameter("width", 0.0)
	else:
		selected = true
		get_node("Sprite2D").material.set_shader_parameter("width", 4.0)

func adopt_by(new_parent):
	adopted = true
	parent = new_parent

func pick():
	$CollisionShape2D.disabled = true
 
func drop():
	$CollisionShape2D.disabled = false

func harvest():
	$CollisionShape2D.disabled = true
	hide()
	
func take_damage(damage):
	health = max(0, health - damage)
	if health == 0:
		die()

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
	for enemy in $ExplodeArea.get_overlapping_bodies():
		if enemy.is_in_group("enemy"):
			enemy.take_damage(2)
			var direction = global_position.direction_to(enemy.global_position)
			enemy.knockback(direction, 750)
