extends Control

func _ready() -> void:
	Dialogic.Styles.change_style("main")
	Dialogic.start("timeline")
