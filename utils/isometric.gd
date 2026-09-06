extends Node

func calculate_direction(from_vector: Vector2, to_vector: Vector2) -> String:
	var direction := (to_vector - from_vector).normalized()
	if direction.x >= 0 and direction.y <= 0:
		return "front"
	elif direction.x >= 0 and direction.y >= 0:
		return "right"
	elif direction.x <= 0 and direction.y >= 0:
		return "back"
	else:
		return "left"
