class_name CharacterAnimation extends Resource

@export var idle_animation: FourWayAnimation
@export var walk_animation: FourWayAnimation
@export var attack_animation: FourWayAnimation

func fetch_animation_data(action_name, facing_name):
	var animation = self.get(action_name + "_animation")
	
	var spritesheet = animation.get(facing_name + "_spritesheet")
	var hframes = animation.hframes
	var vframes = animation.vrames
	var animation_length = animation.length

	return [spritesheet, hframes, vframes, animation_length]
