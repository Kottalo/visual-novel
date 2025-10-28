extends TextureButton

@export var target_control: Control

func _ready() -> void:
	pressed.connect(
		func ():
			target_control.visible = false
	)
