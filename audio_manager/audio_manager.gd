extends Node

enum PlayStatus { PLAY, PAUSE }

@export var playlist: Array[MusicData]
@export var audio_player: AudioStreamPlayer2D

signal play_status_changed
var play_status: PlayStatus = PlayStatus.PLAY:
	set(value):
		play_status = value
		
		match AudioManager.play_status:
			PlayStatus.PLAY:
				audio_player.stream_paused = false
			PlayStatus.PAUSE:
				audio_player.stream_paused = true
		
		emit_signal("play_status_changed")

var track_index: int:
	set(value):
		track_index = value
		if track_index < 0: track_index = playlist.size() - 1
		if track_index >= playlist.size(): track_index = 0
		audio_player.stream = playlist[track_index].track
		audio_player.play()

func _ready() -> void:
	track_index = 0
	play_status = play_status
	
	audio_player.finished.connect(
		func (): Main.track_index += 1
	)
	
	
