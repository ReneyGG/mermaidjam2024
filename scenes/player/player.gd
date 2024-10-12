extends CharacterBody2D

@export var speed = 300
@export var friction = 0.15
@export var acceleration = 0.1
@export var attacking := false

var dead := false
var interact = null
var hold = null
var plant_in_range = null
var storage : Array

func _ready():
	$Sprite2D.play("idle")
	attacking = false

func get_input():
	var input = Vector2()
	
	if Input.is_action_pressed('right'):
		input.x += 1
		$Sprite2D.scale.x = 1
		if hold:
			hold.get_node("Sprite2D").flip_h = true
	if Input.is_action_pressed('left'):
		input.x -= 1
		$Sprite2D.scale.x = -1
		if hold:
			hold.get_node("Sprite2D").flip_h = false
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
			$CanvasLayer/Control/Hold.modulate = hold.color
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
			add_storage(plant_in_range)
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
			add_storage(hold)
			if storage.size() != 2:
				hold = null
			plant_in_range = null
			$PlantArea.monitoring = true
			$CanvasLayer/Control/Hold.texture = null
	return input

func _physics_process(delta):
	if dead:
		return
	
	if hold:
		$Sprite2D/pot.visible = true
		hold.global_position = $Sprite2D/pot.global_position + Vector2(0,-70)
	else:
		$Sprite2D/pot.visible = false
		
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
	
	#$Node2D/AnimatedSprite2D.scale.x = lerp($Node2D/AnimatedSprite2D.scale.x, 1.0, 0.2)
	#$Node2D/AnimatedSprite2D.scale.y = lerp($Node2D/AnimatedSprite2D.scale.y, 1.0, 0.2)

func frame_freeze(timeScale, duration):
	Engine.time_scale = timeScale
	$Freeze.start(duration * timeScale)

func _on_freeze_timeout():
	Engine.time_scale = 1.0

func add_storage(plant):
	if storage.size() == 0:
		storage.append([plant.type,plant.color])
		$CanvasLayer/Control/Slot1.texture = load(get_icon(plant.type))
		$CanvasLayer/Control/Slot1.modulate = plant.color
	elif storage.size() == 1:
		storage.append([plant.type,plant.color])
		$CanvasLayer/Control/Slot2.texture = load(get_icon(plant.type))
		$CanvasLayer/Control/Slot2.modulate = plant.color
		craft()

func craft():
	var plant_scene
	if storage[0][0] == "red" and storage[1][0] == "red":
		$CanvasLayer/Control/Hold.texture = load(get_icon("explosive"))
		$CanvasLayer/Control/Hold.modulate = Color(1.0, 1.0, 0.0, 1.0)
		plant_scene = load("res://scenes/plants/explosive_plant.tscn")
		
	elif storage[0][0] == "blue" and storage[1][0] == "blue":
		$CanvasLayer/Control/Hold.texture = load(get_icon("slowing"))
		$CanvasLayer/Control/Hold.modulate = Color(0.0, 1.0, 1.0, 1.0)
		plant_scene = load("res://scenes/plants/slowing_plant.tscn")
		
	elif (storage[0][0] == "red" and storage[1][0] == "blue") or (storage[0][0] == "blue" and storage[1][0] == "red"):
		$CanvasLayer/Control/Hold.texture = load(get_icon("shooting"))
		$CanvasLayer/Control/Hold.modulate = Color(1.0, 0.0, 1.0, 1.0)
		plant_scene = load("res://scenes/plants/shooting_flower.tscn")
	
	elif storage[0][0] == "shooting" and storage[1][0] == "shooting":
		$CanvasLayer/Control/Hold.texture = load(get_icon("shooting"))
		$CanvasLayer/Control/Hold.modulate = storage[0][1].blend
		plant_scene = load("res://scenes/plants/shooting_flower.tscn")
	
	elif (storage[0][0] == "red" and storage[1][0] == "slowing") or (storage[0][0] == "slowing" and storage[1][0] == "red"):
		pass
	
	elif (storage[0][0] == "red" and storage[1][0] == "explosive") or (storage[0][0] == "explosive" and storage[1][0] == "red"):
		pass
	
	if plant_scene:
		var plant_inst = plant_scene.instantiate()
		get_parent().get_node("PlantSpawner").add_child(plant_inst)
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
		"red":
			return "res://assets/icons/red.png"
		"blue":
			return "res://assets/icons/blue.png"
		"explosive":
			return "res://assets/icons/explosive.png"
		"shooting":
			return "res://assets/icons/shooting.png"
		"slowing":
			return "res://assets/icons/slowing.png"
		"aggro":
			return "res://assets/icons/rose.png"
		"melee":
			return "res://assets/icons/black.png"
		"catapult":
			return "res://assets/icons/black.png"
		"multishoot":
			return "res://assets/icons/black.png"
		"healing":
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
	if plant_in_range:
		plant_in_range.switch_select()
	area.switch_select()
	plant_in_range = area

func _on_plant_area_area_exited(area):
	if area == plant_in_range:
		plant_in_range.switch_select()
		plant_in_range = null
