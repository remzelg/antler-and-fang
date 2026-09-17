@abstract
class_name Spell extends Resource

# Assume the casting character is animated outside of this
# connect events to animation
# setup temporary data state

@export var target_type: TargetType
@export var cost: int
@export var animation_name: String # used to play the right animation on character

enum TargetType {
	SELF,
	MELEE,
	RANGED,
}

enum Conditions {
	BLEED
}

# sprite starts animation
# on cast signal, update state of caster and spawn projectiles and fx, make casting sfx
# on hit signal, despawn projectiles, update target state, play hit animation fx and sfx
# update actual board state if need be.
# spell is complete and can be de-loaded

func cast(caster: Node, targets: Array[Node], source_coord: Vector2, target_coord: Vector2):
	var facing = Utils.isometric.calculate_direction(source_coord, target_coord)
	caster.spell_cast.connect(_on_cast.bind(source_coord, target_coord, facing), Object.CONNECT_ONE_SHOT)
	caster.spell_hit.connect(_on_hit.bind(targets, target_coord), Object.CONNECT_ONE_SHOT)
	caster.play_animation(animation_name, facing)
	
	var anim_player = caster.get_node("AnimationPlayer")
	await anim_player.animation_finished

@abstract func _on_cast(source_coord: Vector2, target_coord: Vector2, facing: String)

@abstract func _on_hit(targets: Array[Node], target_coord: Vector2)

#region Examples
# these are mostly just examples of how to setup a new spell
func _default_ranged_on_cast(source_coord: Vector2, target_coord: Vector2, facing: String):
	pass

func _default_ranged_on_hit(targets: Array[Node], target_coord: Vector2):
	pass
#endregion

#region Helper Functions
func _fire_projectile(origin: Vector2, target: Vector2, duration: float):
	# spawn projectile on origin
	# tween projectile to target
	# despawn projectile
	pass

# update health. The most common update
func _damage(target_character_id: String, amount: int):
	var state = CharacterStateManager._find_character_state_by_id(target_character_id)
	
	state.adjust_health(amount)

# inflict a status on character (could be positive)
func _afflict(target_character_id: Conditions, duration: int):
	pass
#endregion
