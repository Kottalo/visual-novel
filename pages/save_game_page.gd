extends Control

@export var scroll_container: ScrollContainer
@export var grid_container: GridContainer
@export var v_scrollbar: VScrollBar

@onready var target_scrollbar: VScrollBar = scroll_container.get_v_scroll_bar()

func _ready() -> void:
	target_scrollbar.changed.connect(
		func ():
			update_scrollbar()
	)
	
	v_scrollbar.scrolling.connect(
		func ():
			target_scrollbar.value = v_scrollbar.value
	)
	
	target_scrollbar.value_changed.connect(
		func (value: float):
			v_scrollbar.value = target_scrollbar.value
	)
	
	update_scrollbar()

func update_scrollbar() -> void:
	v_scrollbar.max_value = target_scrollbar.max_value
	v_scrollbar.page = target_scrollbar.page
	v_scrollbar.value = target_scrollbar.value
