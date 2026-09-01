extends Node2D

@onready var room = $Room

func _ready():
	room.place("animal", Vector2i(12,2))
	room.place("animal2", Vector2i(9,-2))
	var tile_path = room.get_path_from(Vector2i(9,2), Vector2i(11,2))
	room.move("animal", tile_path)
