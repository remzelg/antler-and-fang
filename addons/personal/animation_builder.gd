@tool
extends EditorScript

# README

# runs in a scene and attempts to build all the animations
# for any nodes in the group "autobattler"
# Looks for animation resources and creates basic animations
# using spritesheets.

func _run():
	# 1. Get the active scene root in the editor
	var scene_root = get_editor_interface().get_edited_scene_root()
	var scene = get_scene()
	if not scene_root:
		print("Please open a scene first!")
		return
	
	var grouped_nodes = scene.get_tree().get_nodes_in_group("autobattler")
	
	for node in grouped_nodes:
		if node.name == "GenericAnimal":
			pass
		else:
			var anim_player = node.get_node("AnimationPlayer")
			var species = node.species
			
			var anim_lib = AnimationLibrary.new()
			var animation = node.animation
			var idle_animation = _create_idle_animation(animation.idle_animation)
			var walk_animation = _create_walk_animation(animation.walk_animation)
			# 7. Save the animation into the library and add to the player
			anim_lib.add_animation("idle", idle_animation)
			anim_lib.add_animation("walk", walk_animation)
			anim_player.add_animation_library(species + "_animations", anim_lib)
			
			print("Animation built successfully in the editor!")

func _create_idle_animation(animation: FourWayAnimation):
	return _create_animation(animation.length, animation.hframes)

func _create_walk_animation(animation: FourWayAnimation):
	return _create_animation(animation.length, animation.hframes)

# unused
func _create_spell_animation(animation: FourWayAnimation):
	var anim = _create_animation(animation.length, animation.hframes)
	
	# 4. Insert a keyframe at 1.5 seconds to invoke our wrapper method
	var cast_time = 0.0 # hardcoding for now
	var hit_time = 2.0 # hardcoding for now
	var cast_data = {
		"method": "_emit_spell_cast",
		"args": []
	}
	var hit_data = {
		"method": "_emit_spell_hit",
		"args": []
	}
	var track_idx = anim.add_track(Animation.TYPE_METHOD)
	anim.track_insert_key(track_idx, cast_time, cast_data)
	anim.track_insert_key(track_idx, hit_time, hit_data)

func _create_animation(duration: float, frames: int):
	# 4. Create the Animation resource
	var anim = Animation.new()
	anim.length = duration # Animation duration in seconds
	
	# 5. Add a track (e.g., animating the position of a Sprite2D named "PlayerSprite")
	var track_path = "Sprite2D:frame"
	var track_idx = anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(track_idx, track_path)
	
	# 6. Insert keyframes (time, value)
	anim.track_insert_key(track_idx, 0.0, 0)
	anim.track_insert_key(track_idx, duration, frames - 1)

	return anim
