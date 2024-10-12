extends CharacterBody2D

var target

@export var health: int = 2
@export var speed: float = 60.0
@export var attack_cooldown: float = 1.0
@export var attack_damage: int = 2 
@onready var attack_timer = $AttackCooldown

var death_effect_scene = preload("res://scenes/effects/death_effect.tscn")

var can_move: bool = true
# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_tree().get_first_node_in_group("base")

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta):
	$Sprite2D.flip_h = velocity.x < 0;
	if !target:
		return
	var direction = global_position.direction_to(target.global_position)
	#print(direction)
	if can_move:
		velocity = direction * speed
	move_and_slide()

func take_damage(damage):
	health = max(0, health - damage)
	if health == 0:
		var death_effect = death_effect_scene.instantiate()
		add_sibling(death_effect)
		death_effect.global_position = global_position
		death_effect.emitting = true
		queue_free()
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
