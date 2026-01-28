class_name SliderEx
extends PanelContainer

@export var value: float
@export var max_value: float = 1

@export var fill: Control
@export var end_point: Control
@export var caret: Control

func _ready() -> void:
	fill.resized.connect(update)
	update.call_deferred()

func update() -> void:
	caret.global_position = end_point.global_position - caret.get_combined_pivot_offset()
