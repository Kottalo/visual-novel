class_name GalleryPage
extends CanvasLayer

@export var gallery_card_pool: Control

func _ready() -> void:
	for gallery_data in Stage.gallery_data_pool:
		for variation in gallery_data.variation:
			var gallery_card: GalleryCard = Prefabs.gallery_card.instantiate()
			gallery_card.texture_rect_base.texture = gallery_data.base
			gallery_card.texture_rect_variation.texture = variation
			gallery_card_pool.add_child(gallery_card)
