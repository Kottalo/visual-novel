class_name SaveProfileCard
extends TextureRect

@export var texture_rect_preview: TextureRect
@export var drag_filter: DragFilter

var hovered: bool:
	set(value):
		hovered = value
		update()

var selected: bool:
	get:
		return Main.selected_save_profile_index == get_index()

func _ready() -> void:
	mouse_entered.connect(
		func ():
			hovered = true
	)
	mouse_exited.connect(
		func ():
			hovered = false
	)
	drag_filter.execute.connect(
		func (): Main.selected_save_profile_index = get_index()
	)
	
	Main.save_profile_index_changed.connect(
		func ():
			update()
	)
	
	update()
	
func update():
	if selected:
		var c: float = 9.5
		modulate = Color(c, c, c)
		var p_c: float = 0.18
		texture_rect_preview.modulate = Color(p_c, p_c, p_c)
	else:
		if hovered:
			modulate = Color(1.35, 1.35, 1.35)
		else:
			modulate = Color(1, 1, 1)
		texture_rect_preview.modulate = Color(1, 1, 1)
