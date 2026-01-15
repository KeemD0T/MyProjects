extends Node2D

var castle_lvl2_scene = preload("res://scenes/LVL2castle.tscn")


func upgrade_castle():
	var old_castle = $Castle
	var new_castle = castle_lvl2_scene.instantiate()
	new_castle.position = old_castle.position
	add_child(new_castle)
	old_castle.queue_free()
	print("Castle upgraded to Level 2!")
