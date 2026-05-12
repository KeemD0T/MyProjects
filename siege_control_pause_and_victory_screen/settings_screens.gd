extends Control

@onready var music_slider: HSlider = $MusicSlider
@onready var sfx_slider: HSlider = $SFXSlider

var waiting_for: String = ""

func _ready():
	# Load saved settings
	var music_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	var sfx_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))

	music_slider.value = db_to_linear(music_db)
	sfx_slider.value = db_to_linear(sfx_db)


func _on_MusicSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	save_settings()


func _on_SFXSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))
	save_settings()


func save_settings():
	var config = ConfigFile.new()
	config.set_value("audio", "music", music_slider.value)
	config.set_value("audio", "sfx", sfx_slider.value)
	config.save("user://settings.cfg")



# ----------------------------
# KEY REBINDING
# ----------------------------

func _on_move_left_pressed() -> void:
	waiting_for = "move_left"
	$BindLabel.text = "Press a key for LEFT..."


func _on_move_right_pressed() -> void:
	waiting_for = "move_right"
	$BindLabel.text = "Press a key for RIGHT..."


func _on_jump_pressed() -> void:
	waiting_for = "jump"
	$BindLabel.text = "Press a key for JUMP..."


func _on_attack_pressed() -> void:
	waiting_for = "attack"
	$BindLabel.text = "Press a key for ATTACK..."


func _input(event):
	if waiting_for != "" and event is InputEventKey and event.pressed:
		rebind_action(waiting_for, event)
		waiting_for = ""
		$BindLabel.text = ""


func rebind_action(action_name: String, event: InputEventKey):
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)
	save_controls()


func save_controls():
	var config = ConfigFile.new()

	for action in ["move_left", "move_right", "jump", "attack"]:
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			config.set_value("controls", action, events[0].as_text())

	config.save("user://settings.cfg")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")
