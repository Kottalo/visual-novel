class_name BookPage
extends Control

@export var dialogue_label: DialogueLabel
@export var pages: Array[DialogueResource]
@export var vbox_page: VBoxContainer
@export var button_previous: TextureButton
@export var button_next: TextureButton
@export var paragraph_container: ParagraphContainer

var line: DialogueLine

func write() -> void:
	line = await pages[0].get_next_dialogue_line(line.next_id if line else "start")
	print(line)
	if line:
		var label = dialogue_label.duplicate()
		var container = paragraph_container.duplicate()
		vbox_page.add_child(container)
		if line.character == "L":
			container.box_left.add_child(label)
		else:
			container.box_right.add_child(label)
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.dialogue_line = line
		label.type_out()
		await label.finished_typing
		await get_tree().create_timer(0.8).timeout
		write()

func _ready() -> void:
	Pages.book = self
	
	button_previous.pressed.connect(
		func ():
			pass
	)
	button_next.pressed.connect(
		func ():
			pass
	)
	
	await write()
