extends Node

var main_menu: MainMenu:
	set(value):
		main_menu = value
		pages_with_bgm.append(main_menu)
var stage: StagePage

#region Stage Pages
var book: BookPage:
	set(value):
		book = value
		pages_with_bgm.append(book)
var profile: ProfilePage:
	set(value):
		profile = value
		pages_with_bgm.append(profile)
var travel: TravelPage
#endregion

var bonus: BonusPage
var character: CharacterPage:
	set(value):
		character = value
		pages_with_bgm.append(character)
var gallery: GalleryPage:
	set(value):
		gallery = value
		pages_with_bgm.append(gallery)
var music: MusicData
var log: LogPage

var _current_page: Control:
	set(value):
		_current_page = value

var pages_with_bgm: Array[Control] = []

func _ready() -> void:
	while pages_with_bgm.size() != 5:
		await get_tree().process_frame
	print("ipda")
	for page in pages_with_bgm:
		page.visibility_changed.connect(
			func ():
				print(123123)
				update_page_bgm(page)
		)
	
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

func switch_page(page: Control):
	_current_page = page
