extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_overworld_texture(filename):
	var path = "res://assets/backgrounds/overworld/" + filename
	$TextureRect.texture = load(path)

func reset_overworld_texture():
	load_overworld_texture("overworld_generated.png")

func _on_town_area_mouse_entered() -> void:
	load_overworld_texture("overworld_selected_town.png")

func _on_town_area_mouse_exited() -> void:
	reset_overworld_texture()

func _on_town_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (Input.is_action_just_pressed("left_click")):
		print("You can't go back to town yet silly")

func _on_mine_area_mouse_entered() -> void:
	load_overworld_texture("overworld_selected_mine.png")

func _on_mine_area_mouse_exited() -> void:
	reset_overworld_texture()

func _on_mine_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (Input.is_action_just_pressed("left_click")):
		print("You entered the mine")

func _on_village_area_mouse_entered() -> void:
	load_overworld_texture("overworld_selected_village.png")

func _on_village_area_mouse_exited() -> void:
	reset_overworld_texture()

func _on_village_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (Input.is_action_just_pressed("left_click")):
		print("You entered the village")

func _on_cabin_area_mouse_entered() -> void:
	load_overworld_texture("overworld_selected_cabin.png")

func _on_cabin_area_mouse_exited() -> void:
	reset_overworld_texture()

func _on_cabin_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (Input.is_action_just_pressed("left_click")):
		print("You entered the old cabin")

func _on_tower_area_mouse_entered() -> void:
	load_overworld_texture("overworld_selected_tower.png")

func _on_tower_area_mouse_exited() -> void:
	reset_overworld_texture()

func _on_tower_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (Input.is_action_just_pressed("left_click")):
		print("You entered the wizard's tower")
