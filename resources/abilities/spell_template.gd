class_name SpellTemplate extends Spell

#var source_character_id: String
#var target_character_id: String
#var source_coord: Vector2
#var target_coord: Vector2

func _on_cast(character: Animal):
	print(get_class() + " cast at " + target_character_id)

func _on_hit(character: Animal):
	print(get_class() + " hit " + target_character_id)
