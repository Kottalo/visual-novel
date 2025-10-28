class_name Game
extends Control

@export var page_container: Control
@export var layer_stage_pages: CanvasLayer
@export var stage_page_container: Control

func _ready() -> void:
	#Stage.start()

	for page: Control in stage_page_container.get_children():
		page.visibility_changed.connect(
			func ():
				layer_stage_pages.visible = page.visible
		)

func switch_page(page_name: String) -> void:
	for page: Control in page_container.get_children():
		page.visible = page.name == page_name
