extends ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	custom_maximum_size = Settings.item_size
	custom_minimum_size = Settings.item_size
	$StaticBody2D.position = Settings.item_size / 2
	$StaticBody2D/CollisionShape2D.shape.size = Settings.item_size

	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Drag.is_dragging:
		modulate = Color(Color.GRAY, 0.7)
	else:
		modulate = Color(Color.GRAY, 0.1)
