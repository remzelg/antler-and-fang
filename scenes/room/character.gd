class_name Character
extends Node2D

# handles character animations

# LEFT, FRONT, RIGHT, BACK
var facing = "FRONT"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	walk()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# TODO: Support warrior as well
func char_name():
	return "wizard"

func walk():
	switch_texture("walk")
	$AnimationPlayer.play("ANIMATION_" + facing)

func idle():
	switch_texture("idle")
	$AnimationPlayer.play("ANIMATION_" + facing)

func attack():
	switch_texture("attack")
	$AnimationPlayer.play("ANIMATION_" + facing)

func die():
	switch_texture("idle")
	$AnimationPlayer.play("ANIMATION_DIE")

func switch_texture(action_name):
	var goal_filename = char_name() + "_" + action_name + ".png"
	var current_texture = $Sprite2D.texture
	
	# Exit if texture is already loaded
	if current_texture && (current_texture.resource_path.get_file() == goal_filename):
		return
	
	var base_path = "res://assets/spritesheets/"
	var new_path = base_path + goal_filename
	
	$Sprite2D.texture = load(new_path)
