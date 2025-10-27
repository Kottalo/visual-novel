extends Node

var save_data: SaveData
var game: Game

var clicked: bool
var dragged: bool

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

func clear_connections(target_signal: Signal):
	for connection in target_signal.get_connections():
		target_signal.disconnect(connection.callable)
