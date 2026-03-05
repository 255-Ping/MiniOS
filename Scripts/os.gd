extends Node2D

var data = DataManager.new()
var command = CommandManager.new()

var command_line_history: Array

@onready var file_node = preload("res://Scenes/file.tscn")
@onready var folder_node = preload("res://Scenes/folder.tscn")

@onready var command_line_input = $ConsoleBackground/CommandLineInput

#####################
#BOOT/INITIALIZATION#
#####################

func _ready() -> void:
	log_string("Initializing... please wait")
	
	log_string("Applying main scene variable to called scripts")
	command.main = self
	command_line_input.main = self
	
	log_string("Loading file ui with user://MiniOS")
	reload_file_manager(data.SAVE_DIR)
	
	log_string("Initialization Complete!")
	
		
#####################
#CONSOLE TEXT SUBMIT#
#####################
		
func _on_line_edit_text_submitted(new_text: String) -> void:
	command_line_history.append(new_text)
	var split = new_text.split(" ")
	var args: Array
	for i in split.size():
		if i > 0:
			args.append(split[i])
	command.run_command(split[0], args)
	clear_console_line(true)
	
func clear_console_line(grab_focus: bool):
	$ConsoleBackground/CommandLineInput.release_focus()
	$ConsoleBackground/CommandLineInput.clear()
	await get_tree().process_frame
	if grab_focus:
		$ConsoleBackground/CommandLineInput.grab_focus()

###############
#LOG FUNCTIONS#
###############

func log_string(string: String):
	var old_console_text = $ConsoleBackground/RichTextLabel.text
	var new_console_text = str(old_console_text, "\n", string)
	$ConsoleBackground/RichTextLabel.text = new_console_text
	
func log_warning(string: String):
	var old_console_text = $ConsoleBackground/RichTextLabel.text
	var new_console_text = str(old_console_text, "\n", "[color=yellow]Warning: ",string, "[/color]")
	$ConsoleBackground/RichTextLabel.text = new_console_text
	
func log_error(string: String):
	var old_console_text = $ConsoleBackground/RichTextLabel.text
	var new_console_text = str(old_console_text, "\n", "[color=red]Error: ",string, "[/color]")
	$ConsoleBackground/RichTextLabel.text = new_console_text
		
#################
#RELOAD FILE GUI#
#################

func reload_file_manager(directory: String):
	for i in $FileSystemBackground/ScrollContainer/FileContainer.get_children():
		i.queue_free()
	
	var dirs
	dirs = data.get_dirs_in_dir(directory)
	for i in dirs.size():
		var instance = folder_node.instantiate()
		instance.folder_name = dirs[i]
		$FileSystemBackground/ScrollContainer/FileContainer.add_child(instance)	
		
	var files
	files = data.get_files_in_dir(directory)
	for i in files.size():
		var instance = file_node.instantiate()
		instance.file_name = files[i]
		$FileSystemBackground/ScrollContainer/FileContainer.add_child(instance)
		
##################################################
#OPEN user://MiniOS FOLDER W/ NATIVE FILE MANAGER#
##################################################
		
func open_data_folder():
	var path = ProjectSettings.globalize_path("user://MiniOS")
	
	# Create the folder if it doesn't exist
	var dir = DirAccess.open(path)
	if dir == null:
		DirAccess.open(ProjectSettings.globalize_path("user://")).make_dir_recursive("MiniOS")
	
	# Open it in the OS file explorer
	OS.shell_open(path)
