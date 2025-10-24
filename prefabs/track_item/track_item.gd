class_name TrackItem
extends TextureButton

@export var drag_filter: DragFilter

func _ready() -> void:
	drag_filter.execute.connect(
		func ():
			AudioManager.track_index = get_index()
	)
