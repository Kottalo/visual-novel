class_name PlayProgressLine
extends ColorRect

@export var play_progress_container: Control
@export var endpoint: Control

func set_progress(ratio: float) -> void:
	ratio = clamp(ratio, 0, 1)
	size.x = play_progress_container.size.x * ratio
