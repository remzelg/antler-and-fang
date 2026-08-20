extends PanelContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# not sure if I need to set both sizes of panel container and color rect
	custom_maximum_size = Settings.item_size
	custom_minimum_size = Settings.item_size
	$ColorRect.custom_maximum_size = Settings.item_size
	$ColorRect.custom_minimum_size = Settings.item_size
	$ColorRect/StaticBody2D/CollisionShape2D.shape.size = Settings.item_size / 1.5
