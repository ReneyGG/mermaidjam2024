extends CharacterBody2D

var target

@export var health: int = 2
@export var speed: float = 60.0
@export var attack_cooldown: float = 1.0
@export var attack_damage: int = 2 
@export var points_amount: int = 1

@onready var attack_timer = $AttackCooldown
@onready var nav = $NavigationAgent2D

var death_effect_scene = preload("res://scenes/effects/death_effect.tscn")

var can_move: bool = true

signal death(points)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.set_frame(randf_range(0, 23))
	target = get_tree().get_first_node_in_group("base")
	connect("death", get_parent().get_parent().update_score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _physics_process(delta):
	if velocity.x < 0 and velocity.length() > 5:
		$Sprite2D.flip_h = true
	elif velocity.x > 0 and velocity.length() > 5:
		$Sprite2D.flip_h = false
	if !target:
		return
	
	nav.target_position = target.global_position
	#var direction = global_position.direction_to(target.global_position)
	var direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	if can_move and global_position.distance_to(target.global_position) > 10:
		velocity = direction * speed
	move_and_slide()

func take_damage(damage):
	health = max(0, health - damage)
	if health == 0:
		GlobalSound.play_sound("res://assets/audio/Death.mp3")
		var death_effect = death_effect_scene.instantiate()
		add_sibling(death_effect)
		death_effect.global_position = global_position
		death_effect.emitting = true
		death.emit(points_amount)
		queue_free()
	GlobalSound.play_sound("res://assets/audio/Guzik.mp3")
	$Sprite2D.material.set_shader_parameter("active",true)
	await get_tree().create_timer(.1).timeout
	$Sprite2D.material.set_shader_parameter("active",false)

func attack():
	#print("attack")
	for area in $AttackArea.get_overlapping_areas():
		if area.has_method("take_damage"):
			area.take_damage(attack_damage)

func knockback(direction, power):
	can_move = false
	var tween = get_tree().create_tween()
	velocity = direction * power
	tween.tween_property(self, "velocity", Vector2.ZERO, 1)
	await tween.finished
	can_move = true

func _on_attack_timer_timeout():
	attack()


func _on_attack_area_body_entered(body):
	if body.is_in_group("player"):
		var direction = global_position.direction_to(body.global_position)
		body.velocity = direction * 1000
		body.move_and_slide()
