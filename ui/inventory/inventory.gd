extends MarginContainer

const ITEM_SCENE = preload("res://ui/inventory/item.tscn")

var inventory: Dictionary[Vector2i, int] = {
	Vector2i(1,1): 123,
}

func load_inventory():
	for key in inventory:
		var item_instance = ITEM_SCENE.instantiate()
		add_child(item_instance)
		item_instance.position = get_inventory_position(key)

func get_inventory_position(vector):
	return (Settings.item_size * vector)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_inventory()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
