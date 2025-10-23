class_name Character
extends Node2D

@export var subviewport: SubViewport
@export var avatar_frame: Control

@export var body_parts: Array[AnimatedSprite2D]
@export var optionals_pool: Node2D

var character_data: CharacterData:
	get:
		return

func _ready() -> void:
	#for body_part in body_parts:
		#body_part.animation_changed.connect(
			#func ():
				#character_data.
		#)
	DialogueManager.got_dialogue.connect(
		func (line: DialogueLine):
			if line.character == self.name:
				var body: String = line.get_tag_value("Body")
				if body:
					var body_part: AnimatedSprite2D = body_parts.filter(
						func (part: AnimatedSprite2D):
							return part.name == "Body"
					).front()
					
					body_part.animation = body
				
				var clear_optionals: bool = "ClearOptionals" in line.tags
				if clear_optionals:
					for additional: Sprite2D in optionals_pool.get_children():
						additional.visible = false
				
				var optionals: String = line.get_tag_value("Optionals")
				if optionals:
					var optionals_array = optionals.split(",")
					for additional in optionals_array:
						var addtional_sprite: Sprite2D = optionals_pool.get_node(additional)
						addtional_sprite.visible = true
	)

func get_avatar_image() -> AtlasTexture:
	var atlas_texture = AtlasTexture.new()
	atlas_texture.atlas = subviewport.get_texture()
	atlas_texture.region = avatar_frame.get_rect()
	
	return atlas_texture
