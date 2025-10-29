class_name Paragraph
extends RichTextLabel

var side: String:
	set(value):
		side = value
		size_flags_horizontal = Control.SIZE_SHRINK_BEGIN \
			if side == "L" else Control.SIZE_SHRINK_END
