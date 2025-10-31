extends Node

var main_menu: MainMenu
var stage: StagePage

#region Stage Pages
var book: BookPage
var profile: ProfilePage
var travel: TravelPage
#endregion

var bonus: BonusPage
var character: CharacterPage
var gallery: GalleryPage
var music: MusicData
var log: LogPage

var current_page: Node:
	set(value):
		current_page = value
		for page in Main.game.main_pages:
			page.visible = page == current_page

#func _ready() -> void:
	#while pages_with_bgm.size() != 5:
		#await get_tree().process_frame
	#print("ipda")
	#for page in pages_with_bgm:
		#page.visibility_changed.connect(
			#func ():
				#if stage:
					#if stage.visible:
						#return
				#update_page_bgm(page)
		#)
	#
	#update_page_bgm(main_menu)

func update_page_bgm(page: Control) -> void:
	var audio_player = AudioManager.audio_player_music
	if page.visible:
		if not audio_player.playing:
			audio_player.stream = \
				AudioManager.playlist[0].track
			audio_player.playing = true
		audio_player.stream_paused = false
	else:
		
		audio_player.playing = false
		audio_player.stream_paused = true
