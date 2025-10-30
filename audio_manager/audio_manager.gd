extends Node

@export var playlist: Array[MusicData]
@export var audio_player_music: AudioStreamPlayer2D
@export var audio_player_sound: AudioStreamPlayer2D
@export var audio_player_voice: AudioStreamPlayer2D
@export var audio_player_bonus: AudioStreamPlayer2D

signal track_index_changed
var track_index: int:
	set(value):
		track_index = value
		if track_index < 0: track_index = playlist.size() - 1
		if track_index >= playlist.size(): track_index = 0
		audio_player_bonus.stream = current_track.track
		track_index_changed.emit()

var current_track: MusicData:
	get:
		return playlist[track_index]

func _ready() -> void:
	track_index = 0
	
	audio_player_bonus.finished.connect(
		func ():
			track_index += 1
			audio_player_bonus.play()
	)
	
func set_track_position_by_ratio(ratio: float):
	var target_position = audio_player_bonus.stream.get_length() * ratio
	audio_player_bonus.stop()
	audio_player_bonus.play(target_position)
