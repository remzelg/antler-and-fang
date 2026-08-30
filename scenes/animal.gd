extends Node2D

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var facing = Vector2i(1,0)

# "badger", "boar", "wolf", or "stag"
@export var species = "badger"

func play_animation(animation, direction):
	load_spritesheet(animation, direction)
	$AnimationPlayer.play("badger" + "_" + animation)

func load_spritesheet(animation_name, direction):
	sprite.vframes = 1 # currently all spritesheets are one level
	if animation_name == "walk" && species == "badger":
		sprite.hframes = 9
	if animation_name == "walk" && species == "boar":
		sprite.hframes = 4
	else:
		print("woops")
		sprite.hframes = 9 # pretty meaningless safeguard
	
	sprite.texture = load("res://assets/spritesheets/" + species + "/walk_" + direction + ".png")
