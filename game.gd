extends Control

@export_flags("Fire", "Water", "Earth", "Wind") var spell_elements = 4

func _ready() -> void:
	Dialogic.start("timeline")

	print(spell_elements)
