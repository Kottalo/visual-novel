class_name VScrollBarEx
extends VScrollBar

@export var target_scroll_container: ScrollContainer

@onready var target_scrollbar: VScrollBar = target_scroll_container.get_v_scroll_bar()

func _ready() -> void:
	target_scrollbar.changed.connect(
		func ():
			update()
	)
	
	scrolling.connect(
		func ():
			target_scrollbar.value = self.value
	)
	
	target_scrollbar.value_changed.connect(
		func (_value: float):
			self.value = _value
	)
	
	update()

func update() -> void:
	max_value = target_scrollbar.max_value
	page = target_scrollbar.page
	self.value = target_scrollbar.value
	visible = page < max_value
