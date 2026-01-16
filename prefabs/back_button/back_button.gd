extends TextureButton

func _ready() -> void:
	pressed.connect(
		func ():
			if Game.stage_page.visible:
				get_parent().visible = false
			else:
				Game.hide_all_pages()
				Game.main_menu.show()
	)
