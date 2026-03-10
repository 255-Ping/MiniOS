extends Control

var file_name: String

func _ready() -> void:
	#Update file name in ui on ready
	$Label.text = file_name
