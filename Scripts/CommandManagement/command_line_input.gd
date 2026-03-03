extends LineEdit

var selected_command_line_history: int = -1

var main

func _process(_delta: float) -> void:
	if main.command_line_history.size() < 1:
		return
	if Input.is_action_just_pressed("ui_up"):
		if main.command_line_history.size() > selected_command_line_history + 1:
			selected_command_line_history += 1
			main.command_line_input.text = main.command_line_history[(main.command_line_history.size() - 1) - selected_command_line_history]
	if Input.is_action_just_pressed("ui_down"):
		selected_command_line_history = -1
		main.command_line_input.text = ""
