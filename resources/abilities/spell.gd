@abstract
class_name Spell extends Resource

# Assume the casting character is animated outside of this
# connect events to animation
# setup temporary data state
var source_character_id: String
var target_character_id: String
var source_coord: Vector2
var target_coord: Vector2

func initialize(character, target_character_id, source_coord, target_coord, direction):
	source_character_id = character.character_id
	target_character_id = target_character_id
	source_coord = source_coord
	target_coord = target_coord
	character.spell_cast.connect(_on_cast, Object.CONNECT_ONE_SHOT)
	character.spell_hit.connect(_on_cast, Object.CONNECT_ONE_SHOT)

@abstract
func _on_cast(character: Animal)

@abstract
func _on_hit(character: Animal)

func _spawn_projectile(projectile_name):
	pass
	# spawn fireball
	# tween fireball over to its target
	# despawn projectile
