extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@onready var map = $"Room/Map"
@export var speed = 1.0
var t = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var point_a = map.get_global_coords_from_tile(Vector2i(10,2))
	var point_b = map.get_global_coords_from_tile(Vector2i(10,-2))
	if (t < 1.0 && map):
		t += delta * speed
		$Character.position = point_a.lerp(point_b, t)

func _input(event: InputEvent) -> void:
	# Check if the event is a mouse button click
	if event is InputEventMouseButton:
		# Check for Left Mouse Button and that it was pressed down (not released)
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print(map.get_tile_from_global_coords(event.position))
