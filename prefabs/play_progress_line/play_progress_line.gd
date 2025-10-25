class_name PlayProgressLine
extends ColorRect

@export var play_progress_container: Control
@export var texture_rect_hint: TextureRect

var hint_visible: bool:
	set(value):
		hint_visible = value
		texture_rect_hint.visible = hint_visible

func set_progress(ratio: float) -> void:
	size.x = play_progress_container.size.x * ratio
