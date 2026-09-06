class_name Animal extends Node2D

signal spell_cast(character_id: String)
signal spell_hit(character_id: String)

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var facing = "front"

# "badger", "boar", "wolf", or "stag"
@export var species: String
@export var character_id: String

@export var animation: CharacterAnimation

func _ready():
	CharacterStateManager.health_changed.connect(_on_health_changed)

func play_animation(action, direction):
	_switch_spritesheet(action, direction)
	$AnimationPlayer.play(species + "_animations/" + action)

func _switch_spritesheet(action, direction):
	var property_name = action + "_animation"
	
	var four_way_sheet = animation.get(property_name)
	
	sprite.vframes = four_way_sheet.vframes
	sprite.hframes = four_way_sheet.hframes
	
	var spritesheet_name = direction + "_spritesheet"

	sprite.texture = four_way_sheet.get(spritesheet_name)

func _on_health_changed(char_id, health_total):
	if character_id == char_id:
		var health_bar = $HealthBar
		
		health_bar.visible = true # make visible once damaged
		health_bar.value = health_total

func _emit_spell_cast():
	spell_cast.emit(character_id)

func _emit_spell_hit():
	spell_hit.emit(character_id)
