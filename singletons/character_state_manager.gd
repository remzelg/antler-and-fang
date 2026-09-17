extends Node

signal health_changed(character_id: String, new_total: int)

@onready var _character_states: Array[CharacterState] = []

func _ready():
	var cs1 = CharacterState.new()
	cs1.character_id = "animal"
	cs1.health = 10
	cs1.mana = 10
	var cs2 = CharacterState.new()
	cs2.character_id = "banimal"
	cs2.health = 10
	cs2.mana = 10
	var cs3 = CharacterState.new()
	cs3.character_id = "bboar"
	cs3.health = 10
	cs3.mana = 10
	var cs4 = CharacterState.new()
	cs4.character_id = "astag"
	cs4.health = 10
	cs4.mana = 10
	_character_states = [cs1, cs2, cs3, cs4]

func adjust_health(character_id: String, delta: int):
	var character_state = _find_character_state_by_id(character_id)
	
	if character_state:
		character_state.health += delta
		
		health_changed.emit(character_id, character_state.health)

func adjust_mana(character_id: String, delta: int):
	pass

# NOTE: read only
func fetch_state(character_id: String):
	var res = _find_character_state_by_id(character_id)
	
	if res:
		return res.duplicate()
	else:
		return null

func _find_character_state_by_id(character_id: String):
	for cs in _character_states:
		if cs.character_id == character_id:
			return cs # Return immediately when found
	return null # Return null if no match exists
