extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_force: float = 380.0
@export var gravity: float = 1000.0

var maxCoyoteTime: float = 0.10
var coyote_time: float

var facing_direction: int = 1 # 1 = right, -1 = left
@export var bullet: PackedScene
@export var bullet_speed: float = 600.0
@export var bulletCooldown: float = 0.3
var bulletTime: float



func _physics_process(delta: float) -> void:
	var input_vector := Vector2.ZERO

	# Horizontal movement
	if Input.is_action_pressed("left"):
		input_vector.x = -1
		facing_direction = -1
	elif Input.is_action_pressed("right"):
		input_vector.x = 1
		facing_direction = 1

	velocity.x = input_vector.x * speed

	if coyote_time > 0.00:
		coyote_time -= delta
	if bulletTime > 0.00:
		bulletTime -= delta

	# Gravity and jumping
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > 0:
			velocity.y += 3.25 * gravity * delta
	else:
		coyote_time = maxCoyoteTime # Reset the "timer"

	if Input.is_action_just_pressed("jump") and coyote_time > 0.0:
		velocity.y = -jump_force
		coyote_time = 0.0

	# Shooting
	if Input.is_action_just_pressed("shoot") and bulletTime <= 0.0:
		shoot_bullet()

	move_and_slide()

func shoot_bullet() -> void:
	if bullet:
		var projectile = bullet.instantiate()
		projectile.global_position = global_position + Vector2(facing_direction * 32, 0)
		projectile.direction = facing_direction
		projectile.speed = bullet_speed
		get_tree().current_scene.add_child(projectile)
		bulletTime = bulletCooldown
