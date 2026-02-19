@tool
extends TileMapLayer
class_name Obscurer
var selected=false
func _ready():
	if Engine.is_editor_hint():
		visible=false
		# Get the editor selection manager
		var editor_selection: EditorSelection = EditorInterface.get_selection()
		
		# Connect the selection_changed signal to a function in this script
		if !editor_selection.is_connected("selection_changed", Callable(self, "_on_editor_selection_changed")):
			editor_selection.connect("selection_changed", Callable(self, "_on_editor_selection_changed"))
	else:
		if get_meta("hidden"):
			material=null
			modulate=Color(1,1,1)
		visible=true
func _on_editor_selection_changed():
	var selected_nodes: Array = EditorInterface.get_selection().get_selected_nodes()
	if selected_nodes.has(self):
		visible=true
		selected=true
	elif selected:
		selected=false
		visible=false
