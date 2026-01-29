extends TextureButton

@export var target_page: CanvasLayer

func _ready() -> void:
	pressed.connect(
		func (): target_page.visible = false
	)
