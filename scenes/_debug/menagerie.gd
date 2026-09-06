extends Node2D

func _ready():
	var animals = get_tree().get_nodes_in_group("autobattler")
	
	for animal in animals:
		if animal.name == "GenericAnimal":
			pass
		else:
			var direction: String
			
			if animal.character_id.begins_with("a_"):
				direction = "front"
			else:
				direction = "back"
			
			animal.play_animation("walk", direction)
