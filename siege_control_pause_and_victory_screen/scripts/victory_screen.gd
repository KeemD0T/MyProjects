extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_play_again_pressed() -> void:
	animation_player.play("FadeOut")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://game.tscn")



func _on_quit_pressed() -> void:
	get_tree().quit()
