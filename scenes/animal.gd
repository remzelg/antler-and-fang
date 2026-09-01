extends Node2D

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var facing = Vector2i(1,0)

# "badger", "boar", "wolf", or "stag"
@export var species: String

func play_animation(animation, direction):
	load_spritesheet(animation, direction)
	$AnimationPlayer.play(species + "_" + animation)

func load_spritesheet(animation_name, direction):
	var texture_path = "res://assets/spritesheets/" + species + "/" + animation_name + "_" + direction + ".png"
	
	if sprite.texture.resource_path != texture_path:
		sprite.texture = load(texture_path)
	
	sprite.vframes = 1 # currently all spritesheets are one level
	if animation_name == "walk" && species == "badger":
		sprite.hframes = 9
	elif animation_name == "walk" && species == "boar":
		sprite.hframes = 4
	elif animation_name == "idle" && species == "badger":
		sprite.hframes = 22
	elif animation_name == "idle" && species == "boar":
		sprite.hframes = 7
	else:
		print("woops")
		sprite.hframes = 9 # pretty meaningless safeguard
	
	
