extends Node
class_name DataManager

const SAVE_DIR := "user://MiniOS"

func get_files_in_dir(directory: String) -> Array[String]:
	var result: Array[String] = []
	var dir := DirAccess.open(str(directory))
	
	if dir == null:
		push_error("Could not open directory: ", dir)
		return result

	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if !dir.current_is_dir():
			result.append(file_name)
		file_name = dir.get_next()

	dir.list_dir_end()
	return result
	
func get_files_in_dir_probe(directory: String) -> Array[String]:
	var result: Array[String] = []
	var dir := DirAccess.open(str("/", directory))
	
	if dir == null:
		push_error(str("Could not open directory: ", dir))
		return result

	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if !dir.current_is_dir():
			result.append(file_name)
		file_name = dir.get_next()

	dir.list_dir_end()
	return result

func get_files_with_extension(extension: String) -> Array[String]:
	var result: Array[String] = []
	var dir := DirAccess.open(SAVE_DIR)

	if dir == null:
		push_error("Could not open directory: " + SAVE_DIR)
		return result

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if !dir.current_is_dir():
			if file_name.get_extension() == extension:
				result.append(file_name)
		file_name = dir.get_next()

	dir.list_dir_end()
	return result

func create_dir(dir: String):
	if not DirAccess.dir_exists_absolute(SAVE_DIR + "/" + dir):
		var result = DirAccess.make_dir_recursive_absolute(SAVE_DIR + "/" + dir)
		if result != OK:
			push_error("Failed to create directory at " + SAVE_DIR + "/" + dir)

func _ensure_dir() -> bool:
	if not DirAccess.dir_exists_absolute(SAVE_DIR):
		var result = DirAccess.make_dir_recursive_absolute(SAVE_DIR)
		if result != OK:
			push_error("Failed to create save directory at " + SAVE_DIR)
			return false
	return true

func save_json(filename: String, data: Dictionary):
	if _ensure_dir():
		var file_path = filename
		var file = FileAccess.open(file_path, FileAccess.WRITE)
		if file:
			file.store_string(JSON.stringify(data, "\t"))
			file.close()
			print("Saved JSON to:", file_path)
		else:
			push_error("Failed to save JSON to " + file_path)

func load_json(filename: String) -> Dictionary:
	var file_path = filename
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			return data
	return {}

func delete_file(filename: String) -> bool:
	var file_path = filename
	if FileAccess.file_exists(file_path):
		var err = DirAccess.remove_absolute(file_path)
		if err == OK:
			print("Deleted file:", file_path)
			return true
		else:
			push_error("Failed to delete file: " + file_path)
	return false

func rename_file(old_name: String, new_name: String) -> bool:
	if not _ensure_dir():
		return false

	var old_path = old_name
	var new_path = new_name

	if not FileAccess.file_exists(old_path):
		return false
	if FileAccess.file_exists(new_path):
		return false

	return DirAccess.rename_absolute(old_path, new_path) == OK
