extends Node2D

# store game state here so it is always at hand.
# maybe just make it a singleton?
var game_state = GameState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		pass
	elif Input.is_action_pressed("ui_left"):
		reset_camera()

func load_town():
	var town_scene = load_scene("res://scenes/overworld/town.tscn")
	town_scene.connect("embark_button_pressed", load_overworld)

func load_overworld():
	load_scene("res://scenes/overworld/overworld.tscn")

# load a tilemap and remove the old one
func load_scene(scene_path) -> Object:
	$MainMenu.visible = false
	var loaded = load(scene_path)
	var instance = loaded.instantiate()
	remove_child($Room)
	add_child(instance)
	
	return instance

func _on_menu_button_pressed() -> void:
	load_town()

var original_camera_pos = Vector2(576.0, 324.0)
@export var zoom_duration: float = 1.0
@onready var camera = $Camera2D

# TODO: Instead of zooming exactly on click, zoom on actual target
func zoom_on_click(target_pos) -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(camera, "global_position", target_pos, zoom_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(camera, "zoom", Vector2(2.0,2.0), zoom_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func reset_camera():
	var tween = create_tween().set_parallel(true)
	tween.tween_property(camera, "global_position", original_camera_pos, zoom_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(camera, "zoom", Vector2(1.0,1.0), zoom_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func setup_main_menu_signals():
	pass
	# connect to all of main menu events
