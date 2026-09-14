extends Node

func calculate_direction(from, to) -> String:
	if typeof(from) == 5: # Vector2
		return _calculate_direction_with_vectors(from, to)
	elif typeof(from) == 6: # Vector2i
		return _calculate_direction_with_tiles(from, to)
	
	push_error("failure to calculate direction")
	return ""

func _calculate_direction_with_vectors(from_coord: Vector2, to_coord: Vector2):
	var direction := (to_coord- from_coord).normalized()
	if direction.x >= 0 and direction.y <= 0:
		return "front"
	elif direction.x >= 0 and direction.y >= 0:
		return "right"
	elif direction.x <= 0 and direction.y >= 0:
		return "back"
	else:
		return "left"

func _calculate_direction_with_tiles(from_cell: Vector2i, to_cell: Vector2i) -> String:
	var delta := from_cell - to_cell

	# A zero-length line has no direction.
	if delta == Vector2i.ZERO:
		return "front"
	
	# Treat tile coordinates as a 2D vector:
	# 0° = straight up / negative Y
	# 90° = right / positive X
	# 180° = down / positive Y
	# 270° = left / negative X
	#
	# In Godot's 2D coordinates, +Y points downward, so negate Y
	# before asking for the angle.
	var angle_degrees := rad_to_deg(atan2(float(delta.x), float(-delta.y)))

	# Convert [-180, 180] to [0, 360).
	angle_degrees = fposmod(angle_degrees, 360.0)

	if angle_degrees >= 0.0 and angle_degrees < 90.0:
		return "back"
	elif angle_degrees >= 90.0 and angle_degrees < 180.0:
		return "left"
	elif angle_degrees >= 180.0 and angle_degrees < 270.0:
		return "front"
	else:
		return "right"

func calculate_distance(from_tile: Vector2i, to_tile: Vector2i) -> int:
	return abs(from_tile.x - to_tile.x) + abs(from_tile.y - to_tile.y)
