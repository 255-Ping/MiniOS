extends Control

var Data = DataManager.new()

var content

func _ready() -> void:
	var split = content.split(" ")
	var text = Data.load_text_file(split[1])
	$TextEdit.text = text
	
