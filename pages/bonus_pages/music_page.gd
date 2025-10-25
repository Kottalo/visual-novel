extends Control

const PlayStatus = AudioManager.PlayStatus

var progress_hovered: bool:
	set(value):
		progress_hovered = value
		progress_hint.modulate.a = 1.0 if not progress_hovered else 0.6
		play_progress_line_ghost.visible = progress_hovered

@export var track_item_scene: PackedScene
@export var play_progress_container: Control
@export var play_progress_line: PlayProgressLine
@export var play_progress_line_ghost: PlayProgressLine
@export var progress_hint: Control
@export var play_button: TextureButton
@export var pause_button: TextureButton
@export var next_button: TextureButton
@export var previous_button: TextureButton
@export var vbox_playlist: VBoxContainer
@export var label_title: Label
@export var richlabel_description: RichTextLabel

var audio_player: AudioStreamPlayer2D:
	get:
		return AudioManager.audio_player

var button_pressed: bool:
	set(value):
		button_pressed = value
		progress_hovered = not button_pressed

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
	AudioManager.track_index_changed.connect(update_track_info)
	
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
	play_progress_container.mouse_entered.connect(
		func (): progress_hovered = true
	)
	play_progress_container.mouse_exited.connect(
		func (): progress_hovered = false
	)
	play_progress_container.gui_input.connect(
		func (event: InputEvent):
			var ratio: float = event.position.x \
			/ play_progress_container.size.x
			if event is InputEventMouseMotion:
				play_progress_line_ghost.set_progress(ratio)
				if button_pressed:
					AudioManager.set_track_position_by_ratio(ratio)
					
			if event is InputEventMouseButton:
				if event.button_index == MOUSE_BUTTON_LEFT:
					if event.is_pressed():
						button_pressed = true
						AudioManager.set_track_position_by_ratio(ratio)
	)
	progress_hovered = false
	update_track_info()

func _unhandled_input(event: InputEvent) -> void:
	if button_pressed:
		if event.is_released():
			button_pressed = false

func _physics_process(delta: float) -> void:
	var progress_ratio = audio_player.get_playback_position() / audio_player.stream.get_length()
	play_progress_line.set_progress(progress_ratio)
	progress_hint.global_position = play_progress_line_ghost \
	.endpoint.global_position \
	if progress_hovered else \
	play_progress_line.endpoint.global_position

func update_track_info() -> void:
	label_title.text = AudioManager.current_track.title
	richlabel_description.text = AudioManager.current_track.description
