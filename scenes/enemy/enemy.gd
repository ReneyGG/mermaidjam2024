extends CharacterBody2D

var base

@export var health: int = 2
@export var speed: float = 60.0
@export var attack_cooldown: float = 1.0
@export var attack_damage: int = 2 
@onready var attack_timer = $AttackCooldown

# Called when the node enters the scene tree for the first time.
func _ready():
	base = get_tree().get_first_node_in_group("base")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !base:
		return
	var direction = global_position.direction_to(base.global_position)
	#print(direction)
	velocity = direction * speed
	move_and_slide()

func take_damage(damage):
	health = max(0, health - damage)
	if health == 0:
		queue_free()

func attack():
	#print("attack")
	for area in $AttackArea.get_overlapping_areas():
		if area.get_parent().has_method("take_damage"):
			area.get_parent().take_damage(attack_damage)

func _on_attack_timer_timeout():
	attack()


func _on_attack_area_body_entered(body):
	if body.is_in_group("player"):
		var direction = global_position.direction_to(body.global_position)
		body.velocity = direction * 1000
		body.move_and_slide()
