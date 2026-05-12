extends CharacterBody2D

@export var SPEED: float = 60.0
@export var JUMP_VELOCITY: float = -300.0
@export var JUMP_MIN_WAIT: float = 2.5
@export var JUMP_MAX_WAIT: float = 3.5
@export var TOUCH_DAMAGE: int = 10
@export var PAUSE_BEFORE_JUMP: float = 0.0
@export var MAX_HP: int = 30

@onready var area: Area2D = $DamageArea
@onready var tick: Timer = $DamageTimer
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_box: Area2D = $hurt_box

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var t_jump: float = 0.0
var castle: Node = null
var player_blocked: bool = false
var pause_left: float = 0.0
var waiting_for_takeoff: bool = false
var hp: int = MAX_HP
var dead: bool = false

func _ready() -> void:
	collision_layer = 0
	collision_mask = 0
	set_collision_layer_value(3, true)
	set_collision_mask_value(1, true)
	set_collision_mask_value(2, true)

	area.collision_mask = 0
	area.set_collision_mask_value(2, true)
	area.set_collision_mask_value(4, true)
	area.monitoring = true
	area.monitorable = true

	hurt_box.collision_layer = 0
	hurt_box.collision_mask = 0
	hurt_box.set_collision_layer_value(6, true) # player listens to this
	hurt_box.monitoring = true
	hurt_box.monitorable = true

	if not area.is_connected("area_entered", _on_area_enter):
		area.area_entered.connect(_on_area_enter)
	if not area.is_connected("area_exited", _on_area_exit):
		area.area_exited.connect(_on_area_exit)
	if not area.is_connected("body_entered", _on_body_enter):
		area.body_entered.connect(_on_body_enter)
	if not area.is_connected("body_exited", _on_body_exit):
		area.body_exited.connect(_on_body_exit)

	if not tick.is_connected("timeout", _on_tick):
		tick.timeout.connect(_on_tick)
	tick.wait_time = 2.0

	add_to_group("Enemy")
	_reset_jump()

func _physics_process(delta: float) -> void:
	if dead: return
	if not is_on_floor():
		velocity.y += gravity * delta
	if player_blocked:
		velocity.x = 0.0
		if pause_left > 0.0:
			pause_left -= delta
		else:
			if is_on_floor() and not waiting_for_takeoff:
				velocity.y = JUMP_VELOCITY
				waiting_for_takeoff = true
			if waiting_for_takeoff and not is_on_floor():
				player_blocked = false
				waiting_for_takeoff = false
				_reset_jump()
	else:
		velocity.x = -SPEED
		t_jump -= delta
		if t_jump <= 0.0 and is_on_floor():
			velocity.y = JUMP_VELOCITY
			_reset_jump()
	move_and_slide()

func _reset_jump() -> void:
	t_jump = randf_range(JUMP_MIN_WAIT, JUMP_MAX_WAIT)

func _find_castle(n: Node) -> Node:
	var cur: Node = n
	while cur:
		if cur.has_method("_take_damage"):
			return cur
		cur = cur.get_parent()
	return null

func _start_castle_damage(c: Node) -> void:
	castle = c
	castle._take_damage(TOUCH_DAMAGE)
	tick.start()

func _stop_castle_damage() -> void:
	castle = null
	tick.stop()

func _on_area_enter(a: Area2D) -> void:
	if a.is_in_group("castle_hurtbox"):
		var c: Node = _find_castle(a)
		if c: _start_castle_damage(c)

func _on_area_exit(a: Area2D) -> void:
	if a.is_in_group("castle_hurtbox") and castle and _find_castle(a) == castle:
		_stop_castle_damage()

func _on_body_enter(b: Node) -> void:
	if b is CharacterBody2D and b.is_in_group("player"):
		player_blocked = true
		pause_left = PAUSE_BEFORE_JUMP
		waiting_for_takeoff = false
	var c: Node = _find_castle(b)
	if c: _start_castle_damage(c)

func _on_body_exit(b: Node) -> void:
	if b is CharacterBody2D and b.is_in_group("player"):
		player_blocked = false
		waiting_for_takeoff = false
	if castle:
		var c: Node = _find_castle(b)
		if c == castle: _stop_castle_damage()

func _on_tick() -> void:
	if castle: castle._take_damage(TOUCH_DAMAGE)
	else: tick.stop()

func take_damage(amount: int) -> void:
	if dead: return
	hp -= amount
	if hp <= 0: die()

func die() -> void:
	dead = true
	tick.stop()
	area.monitoring = false
	hurt_box.monitoring = false
	velocity = Vector2.ZERO
	if anim and anim.sprite_frames and anim.sprite_frames.has_animation("death"):
		anim.play("death")
		anim.animation_finished.connect(func(): queue_free(), CONNECT_ONE_SHOT)
	else:
		queue_free()
