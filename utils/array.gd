extends RefCounted

func pick_random(arr: Array):
	if arr.is_empty():
		return null
	return arr[randi() % arr.size()]

func shuffled(arr: Array) -> Array:
	var copy := arr.duplicate()
	copy.shuffle()
	return copy
