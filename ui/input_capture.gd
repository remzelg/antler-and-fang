extends Control

# There are 2 configurations this could generally follow
# 1: Use Main as the controller for input, and have it direct method calls
# whenever InputCapture receives an input event
# 2 (currently in use): Pass a reference to InputCapture node to the nodes
# that need to respond to input on initialization. They can then respond to
# events at need. Use simple boolean to differentiate between having menus open
# and clicking on the game itself

# Went with option 2, since it makes sense for a simpler game
var menus_open: bool = false

signal board_click_requested(viewport_position: Vector2)

func _gui_input(event: InputEvent) -> void:
	if menus_open:
		# Menu Input Logic
		pass
	else:
		# Game Input Logic
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				board_click_requested.emit(event.position)
				accept_event()
