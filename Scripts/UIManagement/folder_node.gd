extends Control

var folder_name: String

func _ready() -> void:
	#Update file name in ui on ready
	$Label.text = folder_name
