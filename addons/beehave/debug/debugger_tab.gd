@tool
class_name BeehaveDebuggerTab extends PanelContainer

const BeehaveUtils := preload("res://addons/beehave/utils/utils.gd")

signal make_floating

const OldBeehaveGraphEdit := preload("old_graph_edit.gd")
const NewBeehaveGraphEdit := preload("new_graph_edit.gd")
const NewNodeBlackBoard := preload("new_node_blackboard.gd")

const TREE_ICON := preload("../icons/tree.svg")

var graph
var container: HSplitContainer
var graph_container: HSplitContainer
var item_list: ItemList
var blackboard_vbox: VBoxContainer
var message: Label

var active_trees: Dictionary
var active_tree_id: int = -1
var session: EditorDebuggerSession


func _ready() -> void:
	container = HSplitContainer.new()
	add_child(container)

	item_list = ItemList.new()
	item_list.custom_minimum_size = Vector2(200, 0)
	item_list.item_selected.connect(_on_item_selected)
	container.add_child(item_list)

	graph_container = HSplitContainer.new()
	graph_container.split_offset = 1920
	graph_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	container.add_child(graph_container)

	if Engine.get_version_info().minor >= 2:
		graph = NewBeehaveGraphEdit.new(BeehaveUtils.get_frames())
	else:
		graph = OldBeehaveGraphEdit.new(BeehaveUtils.get_frames())

	graph.node_selected.connect(_on_graph_node_selected)
	graph.node_deselected.connect(_on_graph_node_deselected)
	graph_container.add_child(graph)

	blackboard_vbox = VBoxContainer.new()
	blackboard_vbox.custom_minimum_size = Vector2(200, 0)
	blackboard_vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	graph_container.add_child(blackboard_vbox)

	message = Label.new()
	message.text = "Run Project for debugging"
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	message.set_anchors_preset(Control.PRESET_CENTER)
	add_child(message)

	var button := Button.new()
	button.flat = true
	button.name = "MakeFloatingButton"
	button.icon = get_theme_icon(&"ExternalLink", &"EditorIcons")
	button.pressed.connect(func(): make_floating.emit())
	button.tooltip_text = "Make floating"
	button.focus_mode = Control.FOCUS_NONE
	graph.get_menu_container().add_child(button)

	var toggle_button := Button.new()
	toggle_button.flat = true
	toggle_button.name = "TogglePanelButton"
	toggle_button.icon = get_theme_icon(&"Back", &"EditorIcons")
	toggle_button.pressed.connect(_on_toggle_button_pressed.bind(toggle_button))
	toggle_button.tooltip_text = "Toggle Panel"
	toggle_button.focus_mode = Control.FOCUS_NONE
	graph.get_menu_container().add_child(toggle_button)
	graph.get_menu_container().move_child(toggle_button, 0)

	stop()
	visibility_changed.connect(_on_visibility_changed)


func start() -> void:
	container.visible = true
	message.visible = false


func stop() -> void:
	container.visible = false
	message.visible = true

	active_trees.clear()
	item_list.clear()
	graph.beehave_tree = {}


func register_tree(data: Dictionary) -> void:
	if not active_trees.has(data.id):
		var idx := item_list.add_item(data.name, TREE_ICON)
		item_list.set_item_tooltip(idx, data.path)
		item_list.set_item_metadata(idx, data.id)

	active_trees[data.id] = data

	if active_tree_id == data.id.to_int():
		graph.beehave_tree = data


func unregister_tree(instance_id: int) -> void:
	var id := str(instance_id)
	for i in item_list.item_count:
		if item_list.get_item_metadata(i) == id:
			item_list.remove_item(i)
			break

	active_trees.erase(id)

	if graph.beehave_tree.get("id", "") == id:
		graph.beehave_tree = {}


func _on_toggle_button_pressed(toggle_button: Button) -> void:
	item_list.visible = !item_list.visible
	toggle_button.icon = get_theme_icon(
		&"Back" if item_list.visible else &"Forward", &"EditorIcons"
	)


func _on_item_selected(idx: int) -> void:
	var id: StringName = item_list.get_item_metadata(idx)
	graph.beehave_tree = active_trees.get(id, {})

	# Clear our any loaded blackboards
	for child in blackboard_vbox.get_children():
		child.free()

	active_tree_id = id.to_int()
	if session != null:
		session.send_message("beehave:activate_tree", [active_tree_id])

func _on_graph_node_selected(node: GraphNode) -> void:
	var node_blackboard: VBoxContainer = NewNodeBlackBoard.new(BeehaveUtils.get_frames(), node)
	blackboard_vbox.add_child(node_blackboard)

func _on_graph_node_deselected(node: GraphNode) -> void:
	var matches: Array = blackboard_vbox\
		.get_children()\
		.filter(func (child): return child.name == node.name)

	for child in matches:
		child.free()


func _on_visibility_changed() -> void:
	if session != null:
		session.send_message("beehave:visibility_changed", [visible and is_visible_in_tree()])
