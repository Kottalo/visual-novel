extends Control

const PlayStatus = AudioManager.PlayStatus

@export var track_item_scene: PackedScene
@export var play_progress_container: Control
@export var play_progress_line: ColorRect
@export var play_button: TextureButton
@export var pause_button: TextureButton
@export var next_button: TextureButton
@export var previous_button: TextureButton
@export var vbox_playlist: VBoxContainer

var audio_player: AudioStreamPlayer2D:
	get:
		return AudioManager.audio_player

func _ready() -> void:
	for music_data in AudioManager.playlist:
		var track_item: TrackItem = track_item_scene.instantiate()
		track_item.music_data = music_data
		vbox_playlist.add_child(track_item)
	
	AudioManager.play_status_changed.connect(
		func ():
			play_button.visible = false
			pause_button.visible = false
			
			match AudioManager.play_status:
				PlayStatus.PLAY:
					pause_button.visible = true
				PlayStatus.PAUSE:
					play_button.visible = true
	)
	
	play_button.pressed.connect(
		func (): AudioManager.play_status = PlayStatus.PLAY
	)
	pause_button.pressed.connect(
		func (): AudioManager.play_status = PlayStatus.PAUSE
	)
	next_button.pressed.connect(
		func (): AudioManager.track_index += 1
	)
	previous_button.pressed.connect(
		func (): AudioManager.track_index -= 1
	)

func _physics_process(delta: float) -> void:
	play_progress_line.size.x = play_progress_container.size.x * \
	audio_player.get_playback_position() / audio_player.stream.get_length()
