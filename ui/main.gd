extends Node

# Main (Handles Input and connects everything)
#   Game (Handles game logic
#     Board (Stores game state and displays background)
#       Map
#       Grid
#     Display (Animates sprites and effects)
#   UI
#     InputCapture -> Sends signals to main on input

func _ready():
	var ic = $UI/InputCapture
	var game = $Game
	game.initialize(ic)
