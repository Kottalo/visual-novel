class_name LogPage
extends Control

@export var log_line: LogLine
@export var divider: TextureRect
@export var vbox_log_lines: VBoxContainer

func _ready() -> void:
	Pages.log = self
	
	DialogueManager.got_dialogue.connect(
		func (line: DialogueLine):
			if Pages.book.visible: return
			insert_line(line.character, line.text)
	)

func insert_line(character_name: String, text: String) -> void:
	var line: LogLine = log_line.duplicate()
	line.character_name = character_name
	line.dialogue_text = text
	vbox_log_lines.add_child(line)
	vbox_log_lines.add_child(divider.duplicate())
