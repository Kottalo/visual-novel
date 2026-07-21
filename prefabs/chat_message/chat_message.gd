class_name ChatMessage
extends HBoxContainer

var sender_type: Enums.SenderType:
	set(value):
		sender_type = value
		if is_node_ready():
			_apply_style()
var is_self: bool:
	get: return sender_type == Enums.SenderType.SELF

@export var self_bubble_color: Color
@export var frame_left: Control
@export var frame_right: Control
@export var avatar_left: TextureRect
@export var avatar_right: TextureRect
@export var bubble: PanelContainer
@export var message_text: RichTextLabel
@export var bubble_margin: Control

const MIN_TEXT_WIDTH: float = 40.0

func _ready() -> void:
	resized.connect(_check_shrink)

func setup(type: Enums.SenderType, text: String, avatar: Texture2D = null) -> void:
	sender_type = type
	message_text.text = text
	if avatar:
		avatar_left.texture = avatar
		avatar_right.texture = avatar
	_apply_style()
	_apply_layout.call_deferred()

func _apply_style() -> void:
	frame_left.visible = not is_self
	frame_right.visible = is_self
	avatar_left.visible = not is_self
	avatar_right.visible = is_self
	message_text.self_modulate = Color.WHITE if is_self else Color.BLACK
	bubble.self_modulate = self_bubble_color if is_self else Color.WHITE
	alignment = BoxContainer.ALIGNMENT_END if is_self else BoxContainer.ALIGNMENT_BEGIN

func _apply_layout() -> void:
	# 默认展开+换行（安全值）
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	message_text.fit_content = false
	message_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	# 等布局完成后再检查是否需要收缩
	_wait_then_shrink.call_deferred()

func _wait_then_shrink() -> void:
	# 等两帧确保 layout 完全就绪（RichTextLabel 内容更新 + 容器递归排序）
	await get_tree().process_frame
	await get_tree().process_frame
	_check_shrink()

func _check_shrink() -> void:
	# 布局未就绪时保持展开（安全值）
	var row_width: float = _get_row_width()
	if row_width <= 0:
		return
	# 用字体直接算文本宽度，不依赖 message_text.size.x（后者有 fit_content）
	var font: Font = message_text.get_theme_font("normal_font") as Font
	if font == null:
		return
	var font_size: int = message_text.get_theme_font_size("normal_font_size")
	var bubble_padding: float = _get_bubble_horizontal_padding()
	var frame_width: float = _get_visible_frame_width()
	var text_width: float = _get_text_single_line_width(font, font_size)
	var required_width: float = text_width + bubble_padding + frame_width
	var max_text_width: float = maxf(
		MIN_TEXT_WIDTH,
		row_width - bubble_padding - frame_width
	)
	# 文本+气泡边距+头像框总宽度能放下时，才收缩并关闭自动换行。
	if required_width <= row_width:
		size_flags_horizontal = Control.SIZE_SHRINK_END if is_self else Control.SIZE_SHRINK_BEGIN
		message_text.autowrap_mode = TextServer.AUTOWRAP_OFF
		_apply_text_bounds(text_width, font, font_size)
	else:
		size_flags_horizontal = Control.SIZE_EXPAND_FILL
		message_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_apply_text_bounds(max_text_width, font, font_size)

func _get_row_width() -> float:
	var node: Node = get_parent()
	while node:
		if node is ScrollContainer:
			return (node as ScrollContainer).size.x
		node = node.get_parent()
	var parent_control: Control = get_parent() as Control
	if parent_control and parent_control.size.x > 0:
		return parent_control.size.x
	return size.x

func _apply_text_bounds(width: float, font: Font, font_size: int) -> void:
	var bounded_width: float = ceilf(maxf(MIN_TEXT_WIDTH, width))
	message_text.fit_content = false
	message_text.custom_minimum_size.x = bounded_width
	message_text.size.x = bounded_width
	var content_height: float = message_text.get_content_height()
	var line_height: float = font.get_height(font_size) + message_text.get_theme_constant("line_separation")
	message_text.custom_minimum_size.y = ceilf(maxf(content_height, line_height))
	_refresh_container_layout()

func _refresh_container_layout() -> void:
	message_text.update_minimum_size()
	var message_parent: Control = message_text.get_parent() as Control
	if message_parent:
		message_parent.update_minimum_size()
	bubble.update_minimum_size()
	bubble_margin.update_minimum_size()
	update_minimum_size()

	var node: Node = self
	while node:
		if node is Container:
			(node as Container).queue_sort()
		node = node.get_parent()

func _get_text_single_line_width(font: Font, font_size: int) -> float:
	var max_width: float = 0.0
	for line in message_text.text.split("\n", true):
		var line_width: float = font.get_string_size(line, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
		max_width = maxf(max_width, line_width)
	return max_width

func _get_bubble_horizontal_padding() -> float:
	var padding: float = 0.0
	padding += _get_control_horizontal_margin(bubble_margin)
	padding += _get_control_horizontal_margin(message_text.get_parent() as Control)
	var panel_style: StyleBox = bubble.get_theme_stylebox("panel")
	if panel_style:
		padding += panel_style.get_margin(SIDE_LEFT) + panel_style.get_margin(SIDE_RIGHT)
	return padding

func _get_control_horizontal_margin(control: Control) -> float:
	if control == null:
		return 0.0
	return control.get_theme_constant("margin_left") + control.get_theme_constant("margin_right")

func _get_visible_frame_width() -> float:
	var frame_width: float = 0.0
	var frame_count: int = 0
	for frame in [frame_left, frame_right]:
		if frame.visible:
			frame_width += frame.get_combined_minimum_size().x
			frame_count += 1
	if frame_count > 0:
		frame_width += get_theme_constant("separation") * frame_count
	return frame_width
