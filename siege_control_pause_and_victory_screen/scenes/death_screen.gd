extends Node


func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")
	
func _on_quit_pressed() -> void:
	get_tree().quit()
