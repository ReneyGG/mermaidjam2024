extends Node2D

var initial_speed: float
var throw_angle_degrees: float
const gravity: float = 9.8
var time: float = 0.0

var initial_position: Vector2
var throw_direction: Vector2

var z_axis = 0.0 # Simulate throwing the projectile on the z-axis by adding the z-axis to the y-axis
var is_launch: bool = false

@export var time_mult: float = 6.0
@export var damage: int = 1.0
@export var explode_effect_scene: PackedScene

func _process(delta):
	time += delta * time_mult
		
	if is_launch:
		z_axis = initial_speed * sin(deg_to_rad(throw_angle_degrees)) * time - 0.5 * gravity * pow(time, 2)
		
		# If has not touched the ground yet
		if z_axis > 0:
			var x_axis: float = initial_speed * cos(deg_to_rad(throw_angle_degrees)) * time
			global_position = initial_position + throw_direction * x_axis ## Move everything along the 'x-axis'
			
			$Projectile.position.y = -z_axis # Move only the projectile along the y axis based on the simulated z-axis
			return
		explode()

func LaunchProjectile(initial_pos: Vector2, direction: Vector2, desired_distance: float, desired_angle_deg: float):
	initial_position = initial_pos
	throw_direction = direction.normalized()
	
	throw_angle_degrees = desired_angle_deg
	# Find initial speed based on desired distance (R) and desired angle (theta)
	initial_speed = pow(desired_distance * gravity / sin(2 * deg_to_rad(desired_angle_deg)), 0.5)
	
	global_position = initial_position
	time = 0.0
	
	z_axis = 0
	is_launch = true


func explode():
	for enemy in $Projectile/ExplosionArea.get_overlapping_bodies():
		if enemy.is_in_group("enemy"):
			var direction = global_position.direction_to(enemy.global_position)
			enemy.knockback(direction, 300)
			enemy.take_damage(damage)
	var explode_effect = explode_effect_scene.instantiate()
	add_sibling(explode_effect)
	explode_effect.global_position = global_position
	explode_effect.emitting = true
	queue_free()
