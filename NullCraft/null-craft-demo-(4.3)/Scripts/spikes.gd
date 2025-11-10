extends Area2D

var HURTFUL: bool = true

func _on_body_entered(body: Node2D) -> void:
	if HURTFUL and body.name == "player":
		body.modulate = Color.GREEN
