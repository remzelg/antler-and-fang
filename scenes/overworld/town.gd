extends Node2D

signal embark_button_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		var mouse_position = get_viewport().get_mouse_position()
		get_parent().zoom_on_click(mouse_position)

func load_town_texture(filename):
	var path = "res://assets/backgrounds/overworld/" + filename
	$TextureRect.texture = load(path)

func reset_town_texture():
	load_town_texture("town_generated.png")

func _on_doctor_area_mouse_entered() -> void:
	load_town_texture("town_doctor_selected.png")

func _on_doctor_area_mouse_exited() -> void:
	reset_town_texture()

func _on_button_pressed() -> void:
	embark_button_pressed.emit()
