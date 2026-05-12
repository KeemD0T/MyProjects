extends Label

@onready var game_manager: Node = %GameManager

func _process(delta):
	text = "Coins: " + str(game_manager.score)
