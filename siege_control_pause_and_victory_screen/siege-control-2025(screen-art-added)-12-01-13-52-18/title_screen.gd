extends Control


@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_start_pressed() -> void:
	
	$buttonClicked.play()
	
	animation_player.play("FadeOut") 
	# Wait for animation to finish before changing scene
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://game.tscn")


func _on_quit_pressed() -> void:
	
	get_tree().quit()
