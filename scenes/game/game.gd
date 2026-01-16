extends Node

@export var page_pool: Node

@export var main_menu: MainMenu
@export var bonus_page: BonusPage
@export var stage_page: StagePage
@export var profile_page: ProfilePage
@export var travel_page: TravelPage
@export var book_page: BookPage
@export var log_page: LogPage
@export var phone_page: PhonePage

func _ready() -> void:
	hide_all_pages()
	main_menu.show()

func hide_all_pages() -> void:
	for page: CanvasLayer in page_pool.get_children():
		page.visible = false
