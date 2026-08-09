extends Node2D

var RARITIES: Dictionary[int, Color] = {
	0: Color.WHITE,
	1: Color.GREEN,
	2: Color.BLUE,
	3: Color.PURPLE,
}

enum RARITY_NAMES { COMMON, UNCOMMON, RARE, EPIC }

@export var item_id: String

@export var item_frame: int = 1:
	set(value):
		item_frame = value
		$ItemSprite.frame = item_frame

@export var item_rarity: RARITY_NAMES:
	set(value):
		var rarity_name = RARITY_NAMES.find_key(value)
		var material = load("res://assets/resources/shaders/" + rarity_name.to_snake_case() + ".tres")
		$ItemSprite.material = material

# helper for finding right image (frame should match)
# 0 - 3 potions
# 4 - 7 top armor
# 8 - 11 food
# 12 - 15 bottom armor
# 16 - 19 food
# 20 - 23 shields + gauntlets
# 24 - 27 gems
# 28 - 31 shovels + pickaxes
# 32 - 35 meat, gold, bone
# 36 - 39 hammer, sword
# 40 - 43 coins
# 44 - 47 battleaxe, cleaver
# 48 - 51 bomb, boomerang, anvil
# 52 - 55 bow, arrow
# 56 - 59 rings, keys
# 60 - 63 crossbow, dagger

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_frame = 63
	item_rarity = RARITY_NAMES.UNCOMMON
	position = Settings.item_size / 2
	$Area2D.modulate = Color(Color.GRAY, 0.7)

var draggable = false
var is_inside_droppable = false
var body_ref
var initial_position: Vector2
var offset: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if draggable:
		if Input.is_action_just_pressed("left_click"):
			Drag.is_dragging = true
			initial_position = global_position
			offset = get_global_mouse_position() - global_position
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_pressed("left_click"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("left_click"):
			Drag.is_dragging = false
			var tween = get_tree().create_tween()
			if is_inside_droppable:
				print(body_ref)
				tween.tween_property(self, "position", body_ref.position, 0.2).set_ease(Tween.EASE_OUT)
				print("dropped in new slot")
				# actually move item between item slots. do any actions required
			else:
				print("item moved back to original placement")
				tween.tween_property(self, "global_position", initial_position, 0.2).set_ease(Tween.EASE_OUT)

func _on_area_2d_mouse_entered() -> void:
	if not Drag.is_dragging:
		draggable = true
		scale = Vector2(1.05, 1.05)

func _on_area_2d_mouse_exited() -> void:
	if not Drag.is_dragging:
		draggable = false
		scale = Vector2(1,1)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('droppable'):
		is_inside_droppable = true
		body.modulate = Color.PURPLE
		body_ref = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group('droppable'):
		is_inside_droppable = false
		body.modulate = Color.GRAY
		body_ref = null
