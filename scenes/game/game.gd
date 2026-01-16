class_name Game
extends Control

@export var main_pages: Array[Node]
@export var page_container: Control
@export var layer_stage_pages: CanvasLayer
@export var stage_page: CanvasLayer
@export var stage_page_container: Control
@export var stage_page_background: Control

@export var phone_page: Control

func _ready() -> void:
	Main.game = self
	
	for page: Control in stage_page_container.get_children():
		page.visibility_changed.connect(
			func ():
				layer_stage_pages.visible = page.visible
		)
	
	phone_page.visibility_changed.connect(
		func (): stage_page_background.visible = not phone_page.visible
	)

func switch_page(page_name: String) -> void:
	for page: Control in page_container.get_children():
		page.visible = page.name == page_name
