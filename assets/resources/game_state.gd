class_name GameState
extends Resource

var char1: CharacterData # Warrior
var char2: CharacterData # Wizard
var inventory: Array[Resource] # Array of object names

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init():
	pass
