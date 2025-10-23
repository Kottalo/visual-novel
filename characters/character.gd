class_name Character
extends Node2D

@export var subviewport: SubViewport
@export var avatar_frame: Control

@export var body_node: AnimatedSprite2D
@export var body_parts: Array[AnimatedSprite2D]
@export var optionals_pool: Node2D

var body_part_dict: Dictionary[String, AnimatedSprite2D]

var character_data: CharacterData:
	get:
		return

func _ready() -> void:
	for body_part in body_parts:
		body_part_dict[body_part.name] = body_part
		
	DialogueManager.got_dialogue.connect(
		func (line: DialogueLine):
			if line.character == self.name:
				Main.game.balloon.avatar.texture = get_avatar_image()
	)

func get_avatar_image() -> AtlasTexture:
	var atlas_texture = AtlasTexture.new()
	atlas_texture.atlas = subviewport.get_texture()
	atlas_texture.region = avatar_frame.get_rect()
	
	return atlas_texture

#region Dialogue Commands

func FadeIn(position_name: String) -> void:
	var character_sprite: Sprite2D = Sprite2D.new()
	character_sprite.texture = subviewport.get_texture()
	Main.game.character_image_pool.add_child(character_sprite)
	character_sprite.global_position = Main.game.get_position_by_name(position_name)
	character_sprite.global_position.y -= character_sprite.get_rect().size.y / 2 \
	* character_sprite.scale.y
	
# Example: SetParts("Body:校服,Eye:悲伤")
func SetParts(parts_string: String) -> void:
	var parts_array = parts_string.split(",")
	for part in parts_array:
		var part_item: Array[String] = part.split(":")
		var part_name = part_item[0]
		var item_name = part_item[1]
		body_part_dict[part_name].animation = item_name

func ClearOptionals() -> void:
	for additional: Sprite2D in optionals_pool.get_children():
		additional.visible = false

func SetOptionals(optionals_string: String) -> void:
	var optionals_array = optionals_string.split(",")
	for additional in optionals_array:
		var addtional_sprite: Sprite2D = optionals_pool.get_node(additional)
		addtional_sprite.visible = true

#endregion
