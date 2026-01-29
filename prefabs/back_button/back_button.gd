extends TextureButton

@export var target_page: CanvasLayer

func _ready() -> void:
	pressed.connect(
		func ():
			if Game.stage_page.visible:
				target_page.visible = false
			else:
				Game.hide_all_pages()
				Game.main_menu.show()
	)
