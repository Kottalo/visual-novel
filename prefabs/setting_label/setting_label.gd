@tool
class_name SettingLabel
extends Label

@export var title_zh: String:
	set(value):
		title_zh = value
		text = title_zh
@export var title_en: String:
	set(value):
		title_en = value
		label_title_en.text = title_en

@export var label_title_en: Label
