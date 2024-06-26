@tool
extends GraphNode


const BeehaveUtils := preload("res://addons/beehave/utils/utils.gd")

const PORT_TOP_ICON := preload("icons/port_top.svg")
const PORT_BOTTOM_ICON := preload("icons/port_bottom.svg")
const PORT_LEFT_ICON := preload("icons/port_left.svg")
const PORT_RIGHT_ICON := preload("icons/port_right.svg")


@export var title_text: String:
	set(value):
		title_text = value
		if title_label:
			title_label.text = value

@export var text: String:
	set(value):
		text = value
		if label:
			label.text = " " if text.is_empty() else text

@export var icon: Texture2D:
	set(value):
		icon = value
		if icon_rect:
			icon_rect.texture = value

var layout_size: float:
	get:
		return size.y if horizontal else size.x


var icon_rect: TextureRect
var title_label: Label
var label: Label
var titlebar_hbox: HBoxContainer

var frames: RefCounted
var horizontal: bool = false


func _init(frames:RefCounted, horizontal: bool = false) -> void:
	self.frames = frames
	self.horizontal = horizontal


func _ready() -> void:
	custom_minimum_size = Vector2(50, 50) * BeehaveUtils.get_editor_scale()
	draggable = false
	
	add_theme_color_override("close_color", Color.TRANSPARENT)
	add_theme_icon_override("close", ImageTexture.new())

	# For top port
	var top_port: Control = Control.new()
	add_child(top_port)

	icon_rect = TextureRect.new()
	icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	titlebar_hbox = get_titlebar_hbox()
	titlebar_hbox.get_child(0).queue_free()
	titlebar_hbox.alignment = BoxContainer.ALIGNMENT_BEGIN
	titlebar_hbox.add_child(icon_rect)

	title_label = Label.new()
	title_label.add_theme_color_override("font_color", Color.WHITE)
	var title_font: Font = get_theme_font("title_font").duplicate()
	if title_font is FontVariation:
		title_font.variation_embolden = 1
	elif title_font is FontFile:
		title_font.font_weight = 700
	title_label.add_theme_font_override("font", title_font)
	title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_label.text = title_text
	titlebar_hbox.add_child(title_label)

	label = Label.new()
	label.text = " " if text.is_empty() else text
	add_child(label)

	# For bottom port
	add_child(Control.new())

	minimum_size_changed.connect(_on_size_changed)
	_on_size_changed.call_deferred()


func _draw_port(slot_index: int, port_position: Vector2i, left: bool, color: Color) -> void:
	if horizontal:
		if is_slot_enabled_left(1):
			draw_texture(PORT_LEFT_ICON, Vector2(0, size.y / 2) + Vector2(-4, -5), color)
		if is_slot_enabled_right(1):
			draw_texture(PORT_RIGHT_ICON, Vector2(size.x, size.y / 2) + Vector2(-5, -4.5), color)
	else:
		if slot_index == 0 and is_slot_enabled_left(0):
			draw_texture(PORT_TOP_ICON, Vector2(size.x / 2, 0) + Vector2(-4.5, -7), color)
		elif slot_index == 1:
			draw_texture(PORT_BOTTOM_ICON, Vector2(size.x / 2, size.y) + Vector2(-4.5, -5), color)


func get_custom_input_port_position(horizontal: bool) -> Vector2:
	if horizontal:
		return Vector2(0, size.y / 2)
	else:
		return Vector2(size.x/2, 0)


func get_custom_output_port_position(horizontal: bool) -> Vector2:
	if horizontal:
		return Vector2(size.x, size.y / 2)
	else:
		return Vector2(size.x / 2, size.y)


func set_status(status: int) -> void:
	match status:
		0: _set_stylebox_overrides(frames.panel_success, frames.titlebar_success)
		1: _set_stylebox_overrides(frames.panel_failure, frames.titlebar_failure)
		2: _set_stylebox_overrides(frames.panel_running, frames.titlebar_running)
		_: _set_stylebox_overrides(frames.panel_normal, frames.titlebar_normal)


func set_slots(left_enabled: bool, right_enabled: bool) -> void:
	if horizontal:
		set_slot(1, left_enabled, -1, Color.WHITE, right_enabled, -1, Color.WHITE, PORT_LEFT_ICON, PORT_RIGHT_ICON)
	else:
		set_slot(0, left_enabled, -1, Color.WHITE, false, -1, Color.TRANSPARENT, PORT_TOP_ICON, null)
		set_slot(2, false, -1, Color.TRANSPARENT, right_enabled, -1, Color.WHITE, null, PORT_BOTTOM_ICON)


func set_color(color: Color) -> void:
	set_input_color(color)
	set_output_color(color)


func set_input_color(color: Color) -> void:
	set_slot_color_left(1 if horizontal else 0, color)


func set_output_color(color: Color) -> void:
	set_slot_color_right(1 if horizontal else 2, color)


func _set_stylebox_overrides(panel_stylebox: StyleBox, titlebar_stylebox: StyleBox) -> void:
	add_theme_stylebox_override("panel", panel_stylebox)
	add_theme_stylebox_override("titlebar", titlebar_stylebox)


func _on_size_changed():
	add_theme_constant_override("port_offset", 12 * BeehaveUtils.get_editor_scale() if horizontal else round(size.x))
