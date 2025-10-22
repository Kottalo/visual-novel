extends Control

@export var main_dialogue: Resource

func _ready() -> void:
	DialogueManager.got_dialogue.connect(
		func (line: DialogueLine):
			print(line)
	)
	
	DialogueManager.show_dialogue_balloon(main_dialogue, "start")
