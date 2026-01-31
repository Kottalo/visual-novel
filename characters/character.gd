@tool
class_name Character
extends Control

@export var subviewport: SubViewport
@export var texture_rect_avatar: TextureRect

@export var body_parts: Array[AnimatedSprite2D]
@export var optionals_pool: Node2D

var body_part_dict: Dictionary[String, AnimatedSprite2D]
var character_image: Node2D

var character_data: CharacterData:
	get:
		return

# This is for Character Bonus only
signal bonus_part_index_dict_updated
var bonus_part_index_dict: Dictionary[String, Dictionary]

func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	texture_rect_avatar.visible = false
	
	for body_part in body_parts:
		var part_name = body_part.name
		body_part_dict[part_name] = body_part
		
		bonus_part_index_dict[part_name] = {}
		bonus_part_index_dict[part_name]["index"] = 0
		bonus_part_index_dict[part_name]["options"] = \
			Array(body_part_dict[part_name].sprite_frames.get_animation_names())
	
	DialogueManager.got_dialogue.connect(
		func (line: DialogueLine):
			if line.character == self.name:
				Game.stage_page.avatar.texture = texture_rect_avatar.texture
				#Game.stage_page.avatar.texture = get_avatar_image()
	)

func update_bonus_part_index(part_name: String, increment: int) -> void:
	bonus_part_index_dict[part_name].index += increment
	var index: int = bonus_part_index_dict[part_name].index
	var options: Array = bonus_part_index_dict[part_name].options
	if index < 0: bonus_part_index_dict[part_name].index = options.size() - 1
	if index >= options.size(): bonus_part_index_dict[part_name].index = 0
	var body_part: AnimatedSprite2D = body_part_dict[part_name]
	index = bonus_part_index_dict[part_name].index
	body_part.animation = bonus_part_index_dict[part_name].options[index]
	Main.clear_connections(bonus_part_index_dict_updated)
	bonus_part_index_dict_updated.emit()

#func get_avatar_image() -> AtlasTexture:
	#var atlas_texture = AtlasTexture.new()
	#atlas_texture.atlas = subviewport.get_texture()
	#atlas_texture.region = avatar_frame.get_rect()
	#
	#return atlas_texture

@export_tool_button("Print SetParts") var print_set_parts_button = print_set_parts

func print_set_parts() -> void:
	var part_texts = []
	for part in body_parts:
		part_texts.append("%s:%s" % [part.name, part.animation])
	print("""Character("%s").SetParts("%s")""" % [name, ",".join(part_texts)])

#region Dialogue Commands

func FadeIn(position_name: String, duration: float = 0) -> void:
	character_image = Node2D.new()
	var character_sprite = Sprite2D.new()
	character_sprite.texture = subviewport.get_texture()
	character_image.add_child(character_sprite)
	character_sprite.position.y -= character_sprite.get_rect().size.y / 2 \
	* character_image.scale.y
	character_image.modulate.a = 0
	Game.stage_page.character_image_pool.add_child(character_image)
	character_image.global_position = Game.stage_page.get_position_by_name(position_name)
	await create_tween().tween_property(character_image, "modulate:a", 1, duration).finished

func FadeOut(duration: float = 0) -> void:
	await create_tween().tween_property(character_image, "modulate:a", 0, duration).finished
	character_image.queue_free()

func MoveTo(position_name: String, duration: float = 0.5) -> void:
	var target_position: Vector2 = Game.stage_page.get_position_by_name(position_name)
	await create_tween().tween_property(character_image, "global_position", target_position, duration).finished

# Example: SetParts("Body:校服,Eye:悲伤")
func SetParts(parts_string: String) -> void:
	var parts_array = parts_string.split(",")
	for part in parts_array:
		var part_item = part.split(":")
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
