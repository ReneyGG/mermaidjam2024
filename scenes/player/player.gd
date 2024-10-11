extends CharacterBody2D

@export var speed = 180
@export var friction = 0.15
@export var acceleration = 0.1
@export var attacking := false

var dead := false
var interact = null
var hold = null

func _ready():
	#$Camera2D.zoom = Vector2(1,1)
	#$AnimationPlayer.play("idle")
	attacking = false

func get_input():
	var input = Vector2()
	if Input.is_action_pressed('right'):
		input.x += 1
		$Sprite2D.scale.x = -1
	if Input.is_action_pressed('left'):
		input.x -= 1
		$Sprite2D.scale.x = 1
	if Input.is_action_pressed('down'):
		input.y += 1
	if Input.is_action_pressed('up'):
		input.y -= 1
	return input

func _physics_process(delta):
	if dead:
		return
	
	#if hold:
		#$Node2D/AnimatedSprite2D.frame = 1
	#else:
		#$Node2D/AnimatedSprite2D.frame = 0
	
	var direction = get_input()
	#if direction != Vector2(0,0):
		#$DustTrail.emitting = true
	#else:
		#$DustTrail.emitting = false
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	move_and_slide()
	
	#if Input.is_action_just_pressed("attack"):
		#if $AnimationPlayer.current_animation != "attack" and not hold:
			#$Node2D/AnimatedSprite2D.animation = Global.weapon
			#$AnimationPlayer.play("attack")
	#elif Input.is_action_pressed("down") or Input.is_action_pressed("up") or Input.is_action_pressed("right") or Input.is_action_pressed("left"):
		#if $AnimationPlayer.current_animation == "idle" and not attacking:
			#$AnimationPlayer.play("walk")
	#elif not attacking:
		#$AnimationPlayer.play("idle")
	
	#$Node2D/AnimatedSprite2D.scale.x = lerp($Node2D/AnimatedSprite2D.scale.x, 1.0, 0.2)
	#$Node2D/AnimatedSprite2D.scale.y = lerp($Node2D/AnimatedSprite2D.scale.y, 1.0, 0.2)

#func attack():
	#var targets = $Node2D/Area2D.get_overlapping_areas()
	#var hit := false
	#for i in targets:
		#i.get_parent().hit()
	#if targets.size() > 0:
		#$Slap.pitch_scale = randf_range(0.8,1.2)
		#$Slap.play()
		#$Camera2D.apply_shake()
		#$Camera2D/CameraAnimation.play("zoom")
		#frame_freeze(0.1,0.15)

func frame_freeze(timeScale, duration):
	Engine.time_scale = timeScale
	$Freeze.start(duration * timeScale)

func _on_freeze_timeout():
	Engine.time_scale = 1.0

func die(screen):
	if dead:
		return
	dead = true
	#$Camera2D.apply_shake()
	#$Camera2D/CameraAnimation.play("zoom")
	#frame_freeze(0.1,2)
	#await $Freeze.timeout
	#$AnimationPlayer.play("death")
	#await $AnimationPlayer.animation_finished
	#get_parent().get_parent().over(screen)
	#get_tree().paused = true
