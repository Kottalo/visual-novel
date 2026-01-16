extends Node

enum ProfileMode { LOAD, SAVE }

var save_data: SaveData = SaveData.new()
var file_path = "user://save_data.tres"

var clicked: bool
var dragged: bool

var profile_mode: ProfileMode:
	set(value):
		profile_mode = value

signal bonus_tab_index_changed
var bonus_tab_index: int:
	set(value):
		bonus_tab_index = value
		emit_signal("bonus_tab_index_changed")

signal gallery_card_index_changed
var gallery_card_index: int:
	set(value):
		gallery_card_index = value
		emit_signal("gallery_card_index_changed")

signal save_profile_index_changed
var selected_save_profile_index: int:
	set(value):
		selected_save_profile_index = value
		emit_signal("save_profile_index_changed")

func _ready() -> void:
	if FileAccess.file_exists(file_path):
		save_data = load(file_path)

func clear_connections(target_signal: Signal) -> void:
	for connection in target_signal.get_connections():
		target_signal.disconnect(connection.callable)

func clear_children(container: Node) -> void:
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()
