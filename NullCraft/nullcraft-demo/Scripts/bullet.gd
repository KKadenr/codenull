extends Area2D

@export var speed: float = 600.0
var direction: int = 1

func _physics_process(delta: float) -> void:
	position.x += speed * delta * direction

# When the bullet hits something
func _on_body_entered(body: Node) -> void:
	if body is RigidBody2D:
		body.apply_impulse(Vector2(direction * 500, -50))
	elif body is StaticBody2D or body.is_in_group("solid"):
		# Despawn on walls or unmovable solids
		queue_free()
	queue_free()

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
