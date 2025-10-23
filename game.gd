extends Control

@export var main_dialogue: Resource
@export var subviewport: SubViewport

func _ready() -> void:
	DialogueManager.mutated.connect(
		func ():
			print(11)
	)
	
	DialogueManager.show_dialogue_balloon(main_dialogue, "start")
