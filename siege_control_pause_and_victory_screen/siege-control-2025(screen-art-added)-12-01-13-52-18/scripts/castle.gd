extends Node2D
class_name Castle

signal died

@export var max_health: int = 100
var health: float = 0.0             # <- float so fractional regen accumulates
var is_dead := false
var regen_rate: float = 0.0         # hp per second
var regen_active := false

@onready var bar: ProgressBar = $HealthBar/ProgressBar
@onready var hurtbox: Area2D = $HealthBar/Hurtbox
@onready var wall: StaticBody2D = $StaticBody2D

func _ready() -> void:
	health = float(max_health)
	if bar:
		bar.min_value = 0
		bar.max_value = max_health
		bar.value = health
		bar.show_percentage = true
		bar.fill_mode = ProgressBar.FILL_END_TO_BEGIN

	if wall:
		wall.collision_layer = 0
		wall.collision_mask = 0
		wall.set_collision_layer_value(1, true)

	if hurtbox:
		if not hurtbox.is_in_group("castle_hurtbox"):
			hurtbox.add_to_group("castle_hurtbox")
		hurtbox.collision_layer = 0
		hurtbox.collision_mask = 0
		hurtbox.set_collision_layer_value(4, true)
		hurtbox.monitoring = true
		hurtbox.monitorable = true


func _take_damage(amount: int) -> void:
	# convert incoming damage to float-compatible change
	health = clamp(health - float(amount), 0.0, float(max_health))
	if bar:
		bar.value = health

	if is_dead:
		return

	if health <= 0.0:
		is_dead = true
		emit_signal("died")


func increase_max_health(amount: int) -> void:
	max_health += amount
	health += float(amount)
	if bar:
		bar.max_value = max_health
		bar.value = health
	print("Castle max health increased to:", max_health)


# Call this from your store to add +0.5 hp/s
func increase_regen_by(amount: float = 0.5) -> void:
	regen_rate += amount
	regen_active = true
	print("Castle regeneration increased to ", regen_rate, " hp/s")
	# visible confirmation (small immediate heal so player sees result)
	visible_regen_pulse()


func visible_regen_pulse() -> void:
	# If missing health, heal a small immediate chunk (so player sees it)
	if health < float(max_health):
		var missing = float(max_health) - health
		var pulse = min(1.0, missing)  # heal up to 1 HP immediately
		health = min(health + pulse, float(max_health))
		if bar:
			bar.value = health
	else:
		# flash bar green when already full
		if bar:
			var original = bar.modulate
			bar.modulate = Color(0.8, 1.0, 0.8)
			await get_tree().create_timer(0.25).timeout
			bar.modulate = original


func _process(delta: float) -> void:
	# If regen active, accumulate fractional health each frame
	if regen_active and not is_dead and regen_rate > 0.0 and health < float(max_health):
		health = min(health + regen_rate * delta, float(max_health))
		if bar:
			bar.value = health
