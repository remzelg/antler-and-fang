extends Node2D

#region Drawings
# this is for things like highlighting tiles
var TARGET_GREEN = Color(0.564706, 0.933333, 0.564706, 0.6)
var TARGET_YELLOW = Color(1, 1, 0.878431, 0.6)
var TARGET_RED = Color.RED
var WHITE = Color(1,1,1,1)
var BLACK = Color(0,0,0,1)

var default_cell_size = Vector2(64, 32)
# NOTE the keys are world coordinates, not tile coordinates
var colored_tiles: Dictionary = {}
var highlighted_tiles: Dictionary = {}

func _draw():
	for tile in colored_tiles:
		var color = colored_tiles[tile]
		draw_cell(tile, default_cell_size, color, true)
	for tile in highlighted_tiles:
		var color = highlighted_tiles[tile]
		draw_cell(tile, default_cell_size, color, false, 2)

func draw_cell(world_position, cell_size, color, fill, line_width = 1):
	# Calculate the diamond corners for the isometric tile
	var corners = [
		world_position + Vector2(0, -cell_size.y / 2),  # Top
		world_position + Vector2(cell_size.x / 2, 0),   # Right
		world_position + Vector2(0, cell_size.y / 2),   # Bottom
		world_position + Vector2(-cell_size.x / 2, 0)   # Left
	]
	if fill:
		# Draw polygon using the corners
		draw_polygon(PackedVector2Array(corners), [ color ])
	else:
		# Draw lines connecting the corners
		for i in range(corners.size()):
			draw_line(corners[i], corners[(i + 1) % corners.size()], color, line_width)
#endregion
