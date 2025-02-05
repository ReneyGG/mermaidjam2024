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
	$CanvasLayer/Control/Slot1.hide()
	$CanvasLayer/Control/Slot2.hide()
	$CanvasLayer/Control/Hold.hide()

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
		$Sprite2D.scale.y = 0.7
		if plant_in_range and not hold:
			GlobalSound.play_sound("res://assets/audio/Pick_up.mp3")
			plant_in_range.pick()
			hold = plant_in_range
			if $Sprite2D.scale.x == -1:
				hold.get_node("Sprite2D").flip_h = false
			else:
				hold.get_node("Sprite2D").flip_h = true
			$PlantArea.monitoring = false
			plant_in_range = null
			$CanvasLayer/Control/Hold.show()
			$CanvasLayer/Control/Hold.self_modulate = hold.color
		elif hold:
			GlobalSound.play_sound("res://assets/audio/Pick_up.mp3")
			if storage.size() == 2:
				storage.clear()
				$CanvasLayer/Control/Slot1.hide()
				$CanvasLayer/Control/Slot2.hide()
			hold.drop()
			hold = null
			$PlantArea.monitoring = true
			$CanvasLayer/Control/Hold.hide()
	if Input.is_action_just_pressed("harvest"):
		$Sprite2D.scale.y = 0.7
		if plant_in_range and not hold:
			GlobalSound.play_sound("res://assets/audio/Put_out.mp3")
			plant_in_range.harvest()
			add_storage(plant_in_range)
			plant_in_range = null
			$PlantArea.monitoring = false
			await get_tree().physics_frame
			$PlantArea.monitoring = true
		elif hold:
			GlobalSound.play_sound("res://assets/audio/Put_out.mp3")
			if storage.size() == 2:
				storage.clear()
				$CanvasLayer/Control/Slot1.hide()
				$CanvasLayer/Control/Slot2.hide()
			hold.harvest()
			add_storage(hold)
			if storage.size() != 2:
				hold = null
				plant_in_range = null
				$CanvasLayer/Control/Hold.hide()
				$PlantArea.monitoring = false
				await get_tree().physics_frame
				$PlantArea.monitoring = true
			else:
				$PlantArea.monitoring = false
	return input

func _physics_process(delta):
	if dead:
		return
	
	if hold:
		$Sprite2D/pot.visible = true
		hold.global_position = $Sprite2D/pot.global_position + Vector2(11*sign($Sprite2D.scale.x),-40)
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
	$Sprite2D.scale.y = lerp($Sprite2D.scale.y, 1.0, 0.2)

func frame_freeze(timeScale, duration):
	Engine.time_scale = timeScale
	$Freeze.start(duration * timeScale)

func _on_freeze_timeout():
	Engine.time_scale = 1.0

func add_storage(plant):
	if storage.size() == 0:
		storage.append(plant)
		$CanvasLayer/Control/Slot1.show()
		$CanvasLayer/Control/Slot1.self_modulate = plant.color
	elif storage.size() == 1:
		storage.append(plant)
		$CanvasLayer/Control/Slot2.show()
		$CanvasLayer/Control/Slot2.self_modulate = plant.color
		craft()

func craft():
	var plant_scene
	GlobalSound.play_sound("res://assets/audio/Punkt.mp3")
	
	if storage[0].type == "red" or storage[0].type == "blue" or storage[1].type == "red" or storage[1].type == "blue":
		if storage[0].type == "red" and storage[1].type == "red":
			$CanvasLayer/Control/Hold.show()
			$CanvasLayer/Control/Hold.self_modulate = Color("ae595b")
			plant_scene = load("res://scenes/plants/explosive_plant.tscn")
			
		elif storage[0].type == "blue" and storage[1].type == "blue":
			$CanvasLayer/Control/Hold.show()
			$CanvasLayer/Control/Hold.self_modulate = Color("725d55")
			plant_scene = load("res://scenes/plants/slowing_plant.tscn")
			
		elif (storage[0].type == "red" and storage[1].type == "blue") or (storage[0].type == "blue" and storage[1].type == "red"):
			$CanvasLayer/Control/Hold.show()
			$CanvasLayer/Control/Hold.self_modulate = Color("e5bf79")
			plant_scene = load("res://scenes/plants/shooting_flower.tscn")
		
		elif (storage[0].type == "red" and storage[1].type == "shooting") or (storage[0].type == "shooting" and storage[1].type == "red"):
			$CanvasLayer/Control/Hold.show()
			$CanvasLayer/Control/Hold.self_modulate = Color("4f3e6d")
			plant_scene = load("res://scenes/plants/multi_shoot_plant.tscn")
		
		elif (storage[0].type == "red" and storage[1].type == "slowing") or (storage[0].type == "slowing" and storage[1].type == "red"):
			$CanvasLayer/Control/Hold.show()
			$CanvasLayer/Control/Hold.self_modulate = Color("f67c3e")
			plant_scene = load("res://scenes/plants/aggro_plant.tscn")
		
		elif (storage[0].type == "red" and storage[1].type == "explosive") or (storage[0].type == "explosive" and storage[1].type == "red"):
			$CanvasLayer/Control/Hold.show()
			$CanvasLayer/Control/Hold.self_modulate = Color("9d6a89")
			plant_scene = load("res://scenes/plants/catapult_plant.tscn")
		
		elif (storage[0].type == "blue" and storage[1].type == "shooting") or (storage[0].type == "shooting" and storage[1].type == "blue"):
			$CanvasLayer/Control/Hold.show()
			$CanvasLayer/Control/Hold.self_modulate = Color("e2c044")
			plant_scene = load("res://scenes/plants/mele_plant.tscn")
		
		elif (storage[0].type == "blue" and storage[1].type == "slowing") or (storage[0].type == "slowing" and storage[1].type == "blue"):
			$CanvasLayer/Control/Hold.show()
			$CanvasLayer/Control/Hold.self_modulate = Color("698f91")
			plant_scene = load("res://scenes/plants/healing_plant.tscn")
		
		elif (storage[0].type == "blue" and storage[1].type == "explosive") or (storage[0].type == "explosive" and storage[1].type == "blue"):
			$CanvasLayer/Control/Hold.show()
			$CanvasLayer/Control/Hold.self_modulate = Color("b1b8d0")
			plant_scene = load("res://scenes/plants/croos_plant.tscn")
		else:
			print("invalid recipe")
			storage.clear()
			$CanvasLayer/Control/Hold.hide()
			$CanvasLayer/Control/Slot1.hide()
			$CanvasLayer/Control/Slot2.hide()
			hold = null
			$PlantArea.monitoring = true
			plant_in_range = null
			return
	else:
		storage[1].adopt_by(storage[0])
		storage[0].adopted_children.append(storage[1])
		var color0_hue = storage[0].color.h
		var color1_hue = storage[1].color.h
		color0_hue += (color1_hue/3)
		if color0_hue >= 359:
			color0_hue -= 359
		var new_color = storage[0].color
		var new_sat = storage[0].color.s
		if new_sat > storage[1].color.s:
			new_sat = storage[1].color.s
		new_color.h = color0_hue
		new_color.s = new_sat
		storage[0].change_color(new_color)
	
	if plant_scene:
		var plant_inst = plant_scene.instantiate()
		get_parent().get_node("PlantSpawner").add_child(plant_inst)
		plant_inst.global_position = self.global_position
		hold = plant_inst
		$PlantArea.monitoring = false
		plant_in_range = null
	else:
		storage[0].global_position = self.global_position
		hold = storage[0]
		$CanvasLayer/Control/Hold.show()
		$CanvasLayer/Control/Hold.self_modulate = hold.color
		storage[0].show()
		$PlantArea.monitoring = false
		plant_in_range = null
		storage[0].available = true
		storage[1].available = true

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
			return "res://assets/icons/aggro.png"
		"melee":
			return "res://assets/icons/melee.png"
		"catapult":
			return "res://assets/icons/catapult.png"
		"multishoot":
			return "res://assets/icons/multishoot.png"
		"healing":
			return "res://assets/icons/healing.png"
		"cross":
			return "res://assets/icons/cross.png"

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
		plant_in_range.switch_select(false)
	area.switch_select(true)
	plant_in_range = area

func _on_plant_area_area_exited(area):
	if area == plant_in_range:
		plant_in_range.switch_select(false)
		plant_in_range = null
