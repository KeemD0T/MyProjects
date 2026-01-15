extends Control

@onready var music_slider: HSlider = $VBoxContainer4/SliderContainer/MusicSlider
@onready var sfx_slider: HSlider = $VBoxContainer4/SliderContainer/sfxSlider

@onready var jump_button: TextureButton = $VBoxContainer4/HBoxContainer/ButtonContainer/JumpButton
@onready var left_button: TextureButton = $VBoxContainer4/HBoxContainer/ButtonContainer/LeftButton
@onready var right_button: TextureButton = $VBoxContainer4/HBoxContainer/ButtonContainer/RightButton
@onready var attack_button: TextureButton = $VBoxContainer4/HBoxContainer/ButtonContainer/AttackButton

@onready var jump_label: Label = $VBoxContainer4/HBoxContainer/ButtonContainer/JumpButton/JumpLabel
@onready var left_label: Label = $VBoxContainer4/HBoxContainer/ButtonContainer/LeftButton/LeftLabel
@onready var right_label: Label = $VBoxContainer4/HBoxContainer/ButtonContainer/RightButton/RightLabel
@onready var attack_label: Label = $VBoxContainer4/HBoxContainer/ButtonContainer/AttackButton/AttackLabel

# File path for settings configuration
const SETTINGS_PATH = "user://settings.cfg"
var waiting_for_key: String = ""    # which action is being rebound

func _ready() -> void:
	# 🌟 CRITICAL: Set the settings node to ignore the game pause
	self.process_mode = Node.ProcessMode.PROCESS_MODE_ALWAYS
	
	# Load settings first
	load_settings()

	# Initialize sliders from current settings/bus volumes
	music_slider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	sfx_slider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))

	# Connect signals
	music_slider.value_changed.connect(_on_music_slider_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_changed)

	# Connect keybind buttons
	jump_button.pressed.connect(func(): _start_rebind("jump"))
	left_button.pressed.connect(func(): _start_rebind("move_left"))
	right_button.pressed.connect(func(): _start_rebind("move_right"))
	attack_button.pressed.connect(func(): _start_rebind("attack"))
	
	# Update button labels with current keybinds
	_load_control_labels()


# ─────────────────────────────────────────────
#    AUDIO CONTROL
# ─────────────────────────────────────────────

func _on_music_slider_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
	save_settings() # Save changes immediately

func _on_sfx_slider_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)
	save_settings() # Save changes immediately


# ─────────────────────────────────────────────
#    REBINDING SYSTEM
# ─────────────────────────────────────────────

func _start_rebind(action_name: String) -> void:
	waiting_for_key = action_name
	print("Press any key to rebind action:", action_name)


func _input(event: InputEvent) -> void:
	if waiting_for_key == "":
		return

	# Check for key press and ignore common modifier keys alone
	if event is InputEventKey and event.pressed and not event.is_action("ui_text_submit") and event.physical_keycode != KEY_SHIFT and event.physical_keycode != KEY_ALT and event.physical_keycode != KEY_CTRL:
		var new_keycode = event.physical_keycode
		var key_string = OS.get_keycode_string(new_keycode)

		# Clear previous bindings
		InputMap.action_erase_events(waiting_for_key)

		# Assign new binding
		var new_event := InputEventKey.new()
		new_event.physical_keycode = new_keycode 
		InputMap.action_add_event(waiting_for_key, new_event)

		print(waiting_for_key, " rebound to:", key_string)

		# Update the button text and save the new binding
		_update_button_text(waiting_for_key, key_string)
		save_settings()

		waiting_for_key = ""


func _update_button_text(action_name: String, new_text: String) -> void:
	match action_name:
		"jump":
			jump_label.text = new_text
		"move_left":
			left_label.text = new_text
		"move_right":
			right_label.text = new_text
		"attack":
			attack_label.text = new_text

func _load_control_labels() -> void:
	var actions = {
		"jump": jump_label,
		"move_left": left_label,
		"move_right": right_label,
		"attack": attack_label
	}
	
	for action_name in actions:
		var events = InputMap.action_get_events(action_name)
		if not events.is_empty():
			var event = events[0]
			if event is InputEventKey:
				# Use the keycode string for display
				actions[action_name].text = OS.get_keycode_string(event.physical_keycode)


# ─────────────────────────────────────────────
#    WINDOW OPEN/CLOSE & PAUSE/RESUME LOGIC
# ─────────────────────────────────────────────

func _on_settings_button_pressed() -> void:
	var settings_node = get_parent().get_node("Settings2")
	settings_node.visible = true
	# ⏸️ PAUSE: Set the scene tree to paused
	get_tree().paused = true


func _on_exit_button_pressed() -> void:
	var settings_node = get_parent().get_node("Settings2")
	settings_node.visible = false
	# ▶️ RESUME: Set the scene tree back to running
	get_tree().paused = false
	# Ensure any pending key rebind is canceled when exiting
	waiting_for_key = ""
	# Save settings on close as well, just in case
	save_settings()


# ─────────────────────────────────────────────
#    SAVE/LOAD FUNCTIONALITY
# ─────────────────────────────────────────────

func save_settings() -> void:
	var config = ConfigFile.new()

	# --- Save Audio ---
	# Convert Decibels back to linear value (0 to 1) for easier saving/loading
	var music_lin = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	var sfx_lin = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	config.set_value("audio", "music", music_lin)
	config.set_value("audio", "sfx", sfx_lin)

	# --- Save Controls ---
	var actions = ["move_left", "move_right", "jump", "attack"]
	for action in actions:
		var events = InputMap.action_get_events(action)
		if not events.is_empty() and events[0] is InputEventKey:
			var key_event = events[0] as InputEventKey
			# Save the physical keycode as a string for easy storage
			var key_name = OS.get_keycode_string(key_event.physical_keycode)
			config.set_value("controls", action, key_name)
		else:
			config.set_value("controls", action, "") # Save empty if not bound

	var error = config.save(SETTINGS_PATH)
	if error != OK:
		print("Error saving settings to file: ", error)

func load_settings() -> void:
	var config = ConfigFile.new()
	var error = config.load(SETTINGS_PATH)

	if error != OK:
		if error == ERR_FILE_NOT_FOUND:
			print("Settings file not found, using defaults.")
			return # Use default values if file doesn't exist
		else:
			print("Error loading settings file: ", error)
			return

	# --- Load Audio ---
	var music_lin = config.get_value("audio", "music", 1.0) # Default to 1.0 (0db)
	var sfx_lin = config.get_value("audio", "sfx", 1.0)
	
	# Convert linear value back to Decibels and apply to buses
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_lin))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfx_lin))

	# --- Load Controls ---
	var actions = ["move_left", "move_right", "jump", "attack"]
	for action in actions:
		var key_name = config.get_value("controls", action, "")
		
		if key_name != "":
			# VVV CORRECTED LINE VVV
			var keycode = OS.find_keycode_from_string(key_name)
			# ^^^ CORRECTED LINE ^^^
			
			if keycode != 0:
				var ev = InputEventKey.new()
				ev.physical_keycode = keycode

				# Clear default/old mapping and apply the saved one
				InputMap.action_erase_events(action)
				InputMap.action_add_event(action, ev)


func _on_settings_pressed() -> void:
	var settings_node = get_parent().get_node("Settings2")
	settings_node.visible = true
	print("button pressed")
	
