extends Node2D

@onready var animation_player = $AnimationPlayer

func play_animation(animation):
	$AnimationPlayer.play("walk_forward")
