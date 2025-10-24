extends Control

enum PlayStatus { PLAY, PAUSE }

@export var playlist: Array[MusicData]

@export var audio_player: AudioStreamPlayer2D
@export var play_progress_container: Control
@export var play_progress_line: ColorRect
@export var play_button: TextureButton
@export var pause_button: TextureButton
@export var next_button: TextureButton
@export var previous_button: TextureButton

var play_status: PlayStatus = PlayStatus.PLAY:
	set(value):
		play_status = value
		play_button.visible = false
		pause_button.visible = false
		
		match play_status:
			PlayStatus.PLAY:
				pause_button.visible = true
				audio_player.stream_paused = false
				pass
			PlayStatus.PAUSE:
				play_button.visible = true
				audio_player.stream_paused = true
				pass

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
	
	play_button.pressed.connect(
		func (): play_status = PlayStatus.PLAY
	)
	pause_button.pressed.connect(
		func (): play_status = PlayStatus.PAUSE
	)
	next_button.pressed.connect(
		func (): track_index += 1
	)
	previous_button.pressed.connect(
		func (): track_index -= 1
	)
	audio_player.finished.connect(
		func (): track_index += 1
	)

func _physics_process(delta: float) -> void:
	play_progress_line.size.x = play_progress_container.size.x * \
	audio_player.get_playback_position() / audio_player.stream.get_length()
