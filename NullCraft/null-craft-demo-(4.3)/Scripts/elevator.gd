extends Node2D

@export var step_y: float = 40.0		# pixels moved per step
@export var total_states: int = 3		# number of steps before reset
@export var duration: float = 0.18		# tween duration
@export var start_state: int = 0		# 0 or 1 depending on indexing
@export var interval: float = 0.8		# time (seconds) between moves

var curr_state: int
var original_y: float
var _is_tweening: bool = false
var timer: Timer

func _ready() -> void:
	original_y = position.y
	curr_state = start_state

	timer = Timer.new()
	timer.wait_time = interval
	timer.one_shot = false
	timer.autostart = true
	add_child(timer)
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func _on_timer_timeout() -> void:
	if _is_tweening:
		return

	_is_tweening = true
	curr_state += 1

	if curr_state > total_states:
		# Reset back to original position and state
		var tween = create_tween()
		tween.tween_property(self, "position:y", original_y, duration)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		await tween.finished
		curr_state = start_state
		_is_tweening = false
		return

	# Move upward (negative y)
	var target_y = original_y - step_y * curr_state
	var tween = create_tween()
	tween.tween_property(self, "position:y", target_y, duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished
	_is_tweening = false
