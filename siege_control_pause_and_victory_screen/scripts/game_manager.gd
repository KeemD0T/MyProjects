extends Node

signal wave_started(wave_idx: int)
signal wave_cleared(wave_idx: int)
signal all_waves_cleared()

@export var spawn_parent_path: NodePath = NodePath("SpawnPoints")

# Minimum delay between spawns (so they don't go crazy-fast)
const MIN_SPAWN_INTERVAL := 0.3
# Name of the air-only marker for flying enemies
const AIR_MARKER_NAME := "Marker2D3"

# Enemy scenes
const SLIME_SCENE       := preload("res://scenes/slime.tscn")
const GOBLIN_SCENE      := preload("res://scenes/goblin.tscn")
const FLYING_EYE_SCENE  := preload("res://scenes/flying_eye.tscn")
const BOSS_SCENE        := preload("res://scenes/the_final_boss.tscn") 
const FINAL_WAVE_SCENE  := preload("res://FinalWave.tscn")
# Scene paths
const VICTORY_SCREEN_SCENE := "res://scenes/victory_screen.tscn" # 👈 Added Victory Scene Path

# Wave list
var waves: Array[Dictionary] = [
	{ "count": 3,  "duration": 9.0,  "break_after": 6.0, "scenes": [SLIME_SCENE] },
	{ "count": 5,  "duration": 12.0, "break_after": 6.0, "scenes": [SLIME_SCENE, GOBLIN_SCENE] },
	{ "count": 7,  "duration": 12.0, "break_after": 6.0, "scenes": [SLIME_SCENE, GOBLIN_SCENE] },
	{ "count": 9,  "duration": 14.0, "break_after": 8.0, "scenes": [SLIME_SCENE, GOBLIN_SCENE, FLYING_EYE_SCENE] },
	# Wave 5 (index 4): 8 enemies, custom list built at runtime
	{ "count": 8,  "duration": 18.0, "break_after": 0.0, "scenes": [SLIME_SCENE, GOBLIN_SCENE, FLYING_EYE_SCENE, BOSS_SCENE] },
]

enum State { BREAK, SPAWNING, FIGHT, DONE }
var state: State = State.BREAK

var wave_idx: int = -1
var enemies_alive: int = 0
var enemies_left_to_spawn: int = 0
var wave_time_left: float = 0.0

# For wave 5 custom composition
var wave5_list: Array[PackedScene] = []

# Score (optional)
var score: int = 0
@onready var score_label: Label = get_node_or_null("../player/HUD/ScoreLabel") as Label

# Timers
@onready var break_timer: Timer = $BreakTimer
@onready var spawn_timer: Timer = $SpawnPoints/SpawnTimer

# Spawn points
var spawn_points_ground: Array[Node2D] = []
var spawn_points_air: Array[Node2D] = []
var spawn_points_all: Array[Node2D] = []


func _ready() -> void:
	randomize()

	break_timer.one_shot = true
	spawn_timer.one_shot = false

	var parent := get_node_or_null(spawn_parent_path)
	if parent == null:
		push_error("GameManager: set Spawn Parent Path to your SpawnPoints node.")
		return

	for c in parent.get_children():
		if c is Node2D:
			var n := c as Node2D
			if n.name == AIR_MARKER_NAME:
				spawn_points_air.append(n)
			else:
				spawn_points_ground.append(n)
			spawn_points_all.append(n)

	if spawn_points_all.is_empty():
		push_error("GameManager: no markers found under SpawnPoints.")
		return

	_update_score_label()
	_go_to_break(true)

	# Connect to the castle signal
	var castle = get_tree().get_root().find_child("Castle", true, false)
	if castle:
		if not castle.died.is_connected(_on_castle_died):
			castle.died.connect(_on_castle_died)
	else:
		push_warning("Castle node not found! Make sure its name matches exactly.")


func _on_castle_died() -> void:
	var music = get_tree().get_root().find_child("BackGroundMusic", true, false)
	if music:
		music.stop()
	$GameOverSound.play()
	await $GameOverSound.finished
	get_tree().change_scene_to_file("res://scenes/death_screen.tscn")
	$GameOverMusic.play()


func _process(delta: float) -> void:
	if state == State.SPAWNING or state == State.FIGHT:
		wave_time_left = max(0.0, wave_time_left - delta)

	if state == State.FIGHT and enemies_left_to_spawn == 0 and enemies_alive == 0:
		_emit_and_go_to_break()


# ---------------- FLOW ----------------
func _go_to_break(start_now: bool) -> void:
	state = State.BREAK

	if start_now:
		wave_idx = -1
		break_timer.wait_time = 2.0
	else:
		var w := _cur_wave()
		if w.is_empty():
			state = State.DONE
			break_timer.stop()
			spawn_timer.stop()
			all_waves_cleared.emit()
			
			# 🏆 VICTORY: Secondary Scene Change Check
			var music = get_tree().get_root().find_child("BackGroundMusic", true, false)
			if music:
				music.stop()
			
			get_tree().change_scene_to_file(VICTORY_SCREEN_SCENE)
			return
		break_timer.wait_time = float(w["break_after"])

	if not break_timer.timeout.is_connected(_on_break_timeout):
		break_timer.timeout.connect(_on_break_timeout)
	break_timer.start()


func _on_break_timeout() -> void:
	_start_wave()


func _start_wave() -> void:
	wave_idx += 1
	if wave_idx >= waves.size():
		state = State.DONE
		all_waves_cleared.emit()
		
		# 🏆 VICTORY: Primary Scene Change Check
		var music = get_tree().get_root().find_child("BackGroundMusic", true, false)
		if music:
			music.stop()
			
		get_tree().change_scene_to_file(VICTORY_SCREEN_SCENE)
		return

	var w := _cur_wave()
	state = State.SPAWNING

	# Wave 5: build explicit composition
	if wave_idx == 4:
		wave5_list.clear()
		for i in range(3):
			wave5_list.append(FLYING_EYE_SCENE)
		for i in range(4):
			wave5_list.append(GOBLIN_SCENE)
		wave5_list.append(BOSS_SCENE)
		

	var count: int = int(w.get("count", 0))
	if wave_idx == 4:
		count = wave5_list.size()

	var duration: float = float(w.get("duration", 10.0))
	enemies_left_to_spawn = count
	wave_time_left = duration

	var raw_interval: float = duration / max(1.0, float(count))
	var interval: float = max(MIN_SPAWN_INTERVAL, raw_interval)

	spawn_timer.wait_time = interval
	if not spawn_timer.timeout.is_connected(_on_spawn_tick):
		spawn_timer.timeout.connect(_on_spawn_tick)
	spawn_timer.start()

	wave_started.emit(wave_idx)
	print("Wave %d start — count:%d interval:%.2f" % [wave_idx + 1, count, interval])


func _on_spawn_tick() -> void:
	if enemies_left_to_spawn <= 0:
		spawn_timer.stop()
		state = State.FIGHT
		print("Wave %d finished spawning." % (wave_idx + 1))
		return

	_spawn_one()
	enemies_left_to_spawn -= 1

	if enemies_left_to_spawn > 0 and wave_time_left > 0.0:
		var raw_interval: float = wave_time_left / float(enemies_left_to_spawn)
		var interval: float = max(MIN_SPAWN_INTERVAL, raw_interval)
		spawn_timer.wait_time = interval
		spawn_timer.start()
	else:
		spawn_timer.stop()
		state = State.FIGHT
		print("Wave %d finished spawning." % (wave_idx + 1))


func _spawn_one() -> void:
	var w := _cur_wave()
	var enemy_scene: PackedScene = null

	# Wave 5: spawn from fixed list (3 flying, goblins, 1 boss)
	if wave_idx == 4:
		if wave5_list.is_empty():
			return
		enemy_scene = wave5_list.pop_back()
	else:
		var enemy_scenes: Array = w.get("scenes", [])
		if enemy_scenes.is_empty() or spawn_points_all.is_empty():
			return
		enemy_scene = enemy_scenes[randi() % enemy_scenes.size()]

	if enemy_scene == null or spawn_points_all.is_empty():
		return

	var is_flying: bool = (enemy_scene == FLYING_EYE_SCENE) or (enemy_scene == BOSS_SCENE)

	var pool: Array[Node2D]
	if is_flying:
		pool = spawn_points_air if spawn_points_air.size() > 0 else spawn_points_all
	else:
		pool = spawn_points_ground if spawn_points_ground.size() > 0 else spawn_points_all

	if pool.is_empty():
		return

	var marker: Node2D = pool[randi() % pool.size()]

	var enemy := enemy_scene.instantiate() as Node2D
	enemy.global_position = marker.global_position
	get_tree().current_scene.add_child(enemy)

	enemies_alive += 1
	enemy.tree_exited.connect(func ():
		enemies_alive = max(0, enemies_alive - 1)
		add_point(1)
	)


func _emit_and_go_to_break() -> void:
	wave_cleared.emit(wave_idx)
	_go_to_break(false)


func _cur_wave() -> Dictionary:
	if wave_idx < 0 or wave_idx >= waves.size():
		return {}
	return waves[wave_idx]


# ---------------- SCORE ----------------
func add_point(points: int = 1) -> void:
	score += points
	_update_score_label()


func _update_score_label() -> void:
	if score_label:
		score_label.text = "Score: %d" % score


func load_settings():
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		var music = config.get_value("audio", "music", 1)
		var sfx = config.get_value("audio", "sfx", 1)

		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfx))


func load_controls():
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		for action in ["move_left", "move_right", "jump", "attack"]:
			var key_name = config.get_value("controls", action, "")
			if key_name != "":
				var ev = InputEventKey.new()
				
				# 🔑 CORRECTED: Use OS to convert string key name to integer keycode
				var keycode = OS.find_keycode_from_string(key_name)
				
				if keycode != 0:
					# Use physical_keycode for rebindings in Godot 4
					ev.physical_keycode = keycode 
					InputMap.action_erase_events(action)
					InputMap.action_add_event(action, ev)
