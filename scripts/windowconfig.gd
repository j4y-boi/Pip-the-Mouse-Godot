extends Node

var fullscreen = false

func _ready():
	await get_tree().process_frame #to prevent it from trying to set the name before the window exists
	var title = "Pip the Mouse 2"
	if OS.is_debug_build():
		title += " [DEBUG BUILD]"
	DisplayServer.window_set_title(title)

func _input(event):
	if Input.is_action_just_pressed("fullscreen"):
		if fullscreen == false:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			fullscreen = true
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			fullscreen = false
