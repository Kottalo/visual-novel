class_name Character
extends Node2D

@export var subviewport: SubViewport
@export var avatar_frame: Control

var avatar_image:
	get:
		var atlas_texture = AtlasTexture.new()
		atlas_texture.atlas = subviewport.get_texture()
		atlas_texture.region = avatar_frame.get_rect()
		
		return atlas_texture
