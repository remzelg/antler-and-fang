extends Node

var _modules: Dictionary = {}

func _ready() -> void:
	_load_modules()

func _load_modules() -> void:
	var dir := DirAccess.open("res://utils")
	if dir == null:
		push_error("Utils: could not open res://utils")
		return
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".gd"):
			var script := load("res://utils/%s" % file_name)
			if script is GDScript:
				_modules[file_name.get_basename()] = script.new()
		file_name = dir.get_next()
	dir.list_dir_end()

func _get(property: StringName):
	if _modules.has(property):
		return _modules[property]
	return null

func _get_property_list() -> Array:
	var props := []
	for module_name in _modules:
		props.append({"name": module_name, "type": TYPE_OBJECT})
	return props
