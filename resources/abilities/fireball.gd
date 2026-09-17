class_name Fireball extends Spell

func _on_cast(source_coord: Vector2, target_coord: Vector2, facing: String):
	print("cast")

func _on_hit(targets: Array[Node], target_coord: Vector2):
	print("fireball")
