extends Control

var data = DataManager.new()

var content: String
var content_split: Array

func _ready() -> void:
	content_split = content.split(" ")
	var text = data.load_text_file(content_split[1])
	$TextEdit.text = text
	
func _on_save_button_pressed() -> void:
	print(content_split[2])
	data.save_text_file(content_split[2],$TextEdit.text)
