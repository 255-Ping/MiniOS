extends Node
class_name CommandManager

var data = DataManager.new()

var execution_directory: String = data.SAVE_DIR
var probing: bool = false
var main

func run_command(command: String, args: Array):
	
	match command:
		
		"help":
			main.log_string("This is the help command.\n
			Commands List:\n
			help")
		
		"cd":
			if !args:
				main.log_error("Incorrect arguments")
				return
			if not args[0].begins_with("/"):
				execution_directory = str(data.SAVE_DIR, "/", args[0])
				main.reload_file_manager(execution_directory)
				probing = false
			else:
				execution_directory = args[0]
				main.reload_file_manager(execution_directory)
				probing = true
			
		"cdos":
			main.open_data_folder()
			
		"mkfile":
			if !args:
				main.log_error("Incorrect arguments")
				return
			data.save_json(str(execution_directory, "/", args[0]), {})
			main.reload_file_manager(execution_directory)
		
		"mkdir":
			if !args:
				main.log_error("Incorrect arguments")
				return
			data.create_dir(args[0])
			main.reload_file_manager(execution_directory)
			
		"dlfile":
			if !args:
				main.log_error("Incorrect arguments")
				return
			data.delete_file(str(execution_directory, "/", args[0]))
			main.reload_file_manager(execution_directory)
			
		_:
			main.log_string("Unknown or Unregistered command!")
