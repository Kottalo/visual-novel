extends Control

@export var main_dialogue: Resource

var balloon: DialogueBalloon

func _ready() -> void:
	DialogueManager.got_dialogue.connect(
		func (line: DialogueLine):
			balloon.avatar.texture = %"Character".avatar_image
	)
	
	balloon = DialogueManager.show_dialogue_balloon(main_dialogue, "start")
	
	pass
