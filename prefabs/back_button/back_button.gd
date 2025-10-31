extends TextureButton

func _ready() -> void:
	pressed.connect(
		func ():
			if Pages.stage.visible:
				get_parent().visible = false
			else:
				Pages.current_page = Pages.main_menu
	)
