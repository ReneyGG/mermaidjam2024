extends CharacterBody2D

@export var speed = 180
@export var friction = 0.15
@export var acceleration = 0.1
@export var attacking := false

var dead := false
var interact = null
var hold = null
var plant_in_range = null
var storage : Array

func _ready():
	#$Camera2D.zoom = Vector2(1,1)
	#$AnimationPlayer.play("idle")
	$Sprite2D.play("idle")
	attacking = false

func get_input():
	var input = Vector2()
	
	if Input.is_action_pressed('right'):
		input.x += 1
		$Sprite2D.scale.x = 1
	if Input.is_action_pressed('left'):
		input.x -= 1
		$Sprite2D.scale.x = -1
	if Input.is_action_pressed('down'):
		input.y += 1
	if Input.is_action_pressed('up'):
		input.y -= 1
	
	if Input.is_action_just_pressed("pick"):
		if plant_in_range and not hold:
			plant_in_range.pick()
			hold = plant_in_range
			$PlantArea.monitoring = false
			plant_in_range = null
			$CanvasLayer/Control/Hold.texture = load(get_icon(hold.type))
		elif hold:
			if storage.size() == 2:
				storage.clear()
				$CanvasLayer/Control/Slot1.texture = null
				$CanvasLayer/Control/Slot2.texture = null
			hold.drop()
			hold = null
			$PlantArea.monitoring = true
			$CanvasLayer/Control/Hold.texture = null
	if Input.is_action_just_pressed("harvest"):
		if plant_in_range and not hold:
			plant_in_range.harvest()
			add_storage(plant_in_range.type)
			plant_in_range = null
			$PlantArea.monitoring = false
			await get_tree().physics_frame
			$PlantArea.monitoring = true
		elif hold:
			hold.harvest()
			if storage.size() == 2:
				storage.clear()
				$CanvasLayer/Control/Slot1.texture = null
				$CanvasLayer/Control/Slot2.texture = null
			add_storage(hold.type)
			if storage.size() != 2:
				hold = null
			plant_in_range = null
			$PlantArea.monitoring = true
			$CanvasLayer/Control/Hold.texture = null
	return input

func _physics_process(delta):
	if dead:
		return
	
	#if hold:
		#$Node2D/AnimatedSprite2D.frame = 1
	#else:
		#$Node2D/AnimatedSprite2D.frame = 0
	
	if hold:
		hold.global_position = self.global_position
	
	var direction = await get_input()
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

func add_storage(type):
	if storage.size() == 0:
		storage.append(type)
		$CanvasLayer/Control/Slot1.texture = load(get_icon(type))
	elif storage.size() == 1:
		storage.append(type)
		$CanvasLayer/Control/Slot2.texture = load(get_icon(type))
		craft()

func craft():
	var plant_scene
	if storage == ["red","red"]:
		$CanvasLayer/Control/Hold.texture = load(get_icon("pink"))
		plant_scene = load("res://scenes/craft_test/rose.tscn")
	elif storage == ["blue","blue"]:
		$CanvasLayer/Control/Hold.texture = load(get_icon("black"))
		plant_scene = load("res://scenes/craft_test/black.tscn")
	elif storage == ["red","blue"] or  storage == ["blue","red"]:
		$CanvasLayer/Control/Hold.texture = load(get_icon("purple"))
		plant_scene = load("res://scenes/craft_test/purple.tscn")
	
	if plant_scene:
		var plant_inst = plant_scene.instantiate()
		get_parent().get_node("Plants").add_child(plant_inst)
		plant_inst.global_position = self.global_position
		hold = plant_inst
		$PlantArea.monitoring = false
		plant_in_range = null
	else:
		hold = null
		$PlantArea.monitoring = true
		plant_in_range = null

func get_icon(type):
	match type:
		"explosive":
			return "res://assets/icons/red.png"
		"shooting":
			return "res://assets/icons/blue.png"
		"slowing":
			return "res://assets/icons/purple.png"
		"aggro":
			return "res://assets/icons/rose.png"
		"black":
			return "res://assets/icons/black.png"

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

func _on_plant_area_area_entered(area):
	plant_in_range = area
	plant_in_range.get_node("Sprite2D").material.set("shader_paramater/width",10.0)

func _on_plant_area_area_exited(area):
	if area == plant_in_range:
		plant_in_range.get_node("Sprite2D").material.set("shader_paramater/width",0.0)
		plant_in_range = null
