extends Area2D

@onready var game_manager: Node = %GameManager
@onready var pick_up_animation: AnimationPlayer = $PickUpAnimation


func _on_body_entered(body: Node2D) -> void:
	game_manager.add_point()
	pick_up_animation.play("PickUpAnimation")
	print("Coin(s) Collected")
