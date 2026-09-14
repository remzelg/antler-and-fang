class_name Map extends Node2D

@onready var map: TileMapLayer = $Ground
@onready var drawer: Node2D = $Ground/Drawer

func used_tiles() -> Array[Vector2i]:
	return map.get_used_cells()

func local_to_map(global_coords: Vector2):
	return map.local_to_map(global_coords)

func map_to_local(tile: Vector2i):
	return Vector2i(map.map_to_local(tile))

#region Drawer
func highlight_tile(tile, color = Color.YELLOW):
	var coords = map_to_local(tile)
	drawer.highlighted_tiles[coords] = Color.YELLOW
	drawer.queue_redraw()

func fill_tile(tile, color = Color.YELLOW):
	var coords = map_to_local(tile)
	drawer.colored_tiles[coords] = Color.YELLOW
	drawer.queue_redraw()

func clear_all_tiles():
	drawer.highlighted_tiles = {}
	drawer.colored_tiles = {}
	drawer.queue_redraw()
#endregion
