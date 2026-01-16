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
var phone: PhonePage

var current_page: Node:
	set(value):
		current_page = value
		for page in Main.game.main_pages:
			page.visible = page == current_page
		update_page_bgm()

func _ready() -> void:
	while not main_menu: await get_tree().process_frame
	current_page = main_menu

func update_page_bgm() -> void:
	var audio_player = AudioManager.audio_player_music
	
	if not audio_player.playing:
		audio_player.stream = \
			AudioManager.playlist[0].track
		audio_player.playing = true
	
	if current_page == stage or current_page == music:
		audio_player.playing = false
