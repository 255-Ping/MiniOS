extends Control

var resizing = false
var resize_margin = 8
var resize_dir = Vector2.ZERO

func _ready():
	print("size:", size)
	
#func _draw():
#	draw_rect(Rect2(Vector2.ZERO, size), Color(1,0,0,0.2))

func _process(_delta):
	var pos = get_local_mouse_position()
	var dir = get_resize_direction(pos)

	if dir.x != 0 and dir.y == 0:
		mouse_default_cursor_shape = Control.CURSOR_HSIZE
	elif dir.y != 0 and dir.x == 0:
		mouse_default_cursor_shape = Control.CURSOR_VSIZE
	elif dir.x != 0 and dir.y != 0:
		mouse_default_cursor_shape = Control.CURSOR_FDIAGSIZE
	else:
		mouse_default_cursor_shape = Control.CURSOR_ARROW


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				resize_dir = get_resize_direction(get_local_mouse_position())
				if resize_dir != Vector2.ZERO:
					resizing = true
			else:
				resizing = false


func _input(event):
	if resizing and event is InputEventMouseMotion:
		resize_window(event.relative)


func get_resize_direction(pos):
	var dir = Vector2.ZERO
	
	if pos.x < resize_margin:
		dir.x = -1
	elif pos.x > size.x - resize_margin:
		dir.x = 1
		
	if pos.y < resize_margin:
		dir.y = -1
	elif pos.y > size.y - resize_margin:
		dir.y = 1
		
	return dir


func resize_window(rel):
	if resize_dir.x == 1:
		size.x += rel.x
	elif resize_dir.x == -1:
		size.x -= rel.x
		position.x += rel.x
		
	if resize_dir.y == 1:
		size.y += rel.y
	elif resize_dir.y == -1:
		size.y -= rel.y
		position.y += rel.y

	size.x = max(size.x, 300)
	size.y = max(size.y, 200)
