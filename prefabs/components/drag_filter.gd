class_name DragFilter
extends Node

signal execute

@export var target_object: Control

func _ready() -> void:
	target_object.gui_input.connect(
		func (event: InputEvent):
			if event is InputEventMouseButton:
				if event.button_index == MOUSE_BUTTON_LEFT:
					if event.is_pressed():
						Main.clicked = true
						Main.dragged = false
					if event.is_released():
						if not Main.dragged and Main.clicked:
							emit_signal("execute")
							Main.clicked = false
						Main.dragged = false
			if event is InputEventMouseMotion:
				if Main.clicked:
					Main.dragged = true
				
	)
