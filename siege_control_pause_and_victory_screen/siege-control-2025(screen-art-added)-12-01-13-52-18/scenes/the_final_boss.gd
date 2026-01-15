extends CharacterBody2D

@export var SPEED: float = 20.0
@export var TOUCH_DAMAGE: int = 10          # damage to castle
@export var MAX_HP: int = 100

# knockback numbers – tweak these to taste
@export var PLAYER_KNOCKBACK_X: float = 500.0   # horizontal force (right)
@export var PLAYER_KNOCKBACK_Y: float = -600.0  # vertical force (up)
@export var PLAYER_KNOCKBACK_DELAY: float = 1.1 # delay before launch
@export var PLAYER_KNOCKBACK_COOLDOWN: float = 0.5 # extra cooldown after launch

@onready var area: Area2D = $AttackArea      # used for castle + player detect
@onready var tick: Timer = $DamageTimer
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_box: Area2D = $HurtBox

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var castle: Node = null
var hp: int
var dead: bool = false
var attacking_castle: bool = false

# we now allow multiple hits, just not at the same time
var is_knocking_player: bool = false


func _ready() -> void:
	hp = MAX_HP

	area.monitoring = true
	area.monitorable = true

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

	if not hurt_box.is_connected("area_entered", _on_hurt_box_area_enter):
		hurt_box.area_entered.connect(_on_hurt_box_area_enter)

	add_to_group("Enemy")

	if anim:
		anim.play("walk")


func _physics_process(delta: float) -> void:
	if dead:
		return

	if not is_on_floor():
		velocity.y += gravity * delta

	if attacking_castle:
		velocity.x = 0.0
	else:
		velocity.x = -SPEED

	move_and_slide()

	if anim:
		anim.flip_h = velocity.x > 0


# ---------- CASTLE HELPERS ----------

func _find_castle(n: Node) -> Node:
	var cur: Node = n
	while cur:
		if cur.has_method("_take_damage"):
			return cur
		cur = cur.get_parent()
	return null


func _start_castle_damage(c: Node) -> void:
	castle = c
	attacking_castle = true
	velocity = Vector2.ZERO

	if anim and anim.sprite_frames and anim.sprite_frames.has_animation("attack"):
		anim.play("attack")

	if castle.has_method("_take_damage"):
		castle._take_damage(TOUCH_DAMAGE)

	tick.start()


func _stop_castle_damage() -> void:
	attacking_castle = false
	castle = null
	tick.stop()

	if not dead and anim and anim.sprite_frames.has_animation("walk"):
		anim.play("walk")


# ---------- ATTACK AREA ----------

func _on_area_enter(a: Area2D) -> void:
	if dead:
		return

	# Castle hurtbox
	if a.is_in_group("castle_hurtbox"):
		var c: Node = _find_castle(a)
		if c:
			_start_castle_damage(c)
		return

	# we only handle player via body_enter to avoid double-calls


func _on_area_exit(a: Area2D) -> void:
	if a.is_in_group("castle_hurtbox") and castle and _find_castle(a) == castle:
		_stop_castle_damage()


# ---------- BODY ENTER/EXIT ----------

func _on_body_enter(b: Node) -> void:
	if dead:
		return

	# PLAYER: any CharacterBody2D that is NOT an enemy and not self
	# (so it won’t launch slimes/goblins/bosses)
	if not attacking_castle and b is CharacterBody2D and b != self and not b.is_in_group("Enemy"):
		_knockback_player(b)
		return

	# CASTLE body (fallback)
	var c: Node = _find_castle(b)
	if c:
		_start_castle_damage(c)


func _on_body_exit(b: Node) -> void:
	if castle:
		var c: Node = _find_castle(b)
		if c == castle:
			_stop_castle_damage()


func _on_tick() -> void:
	if castle and castle.has_method("_take_damage"):
		castle._take_damage(TOUCH_DAMAGE)
	else:
		_stop_castle_damage()


# ---------- PLAYER → BOSS DAMAGE ----------

func _on_hurt_box_area_enter(a: Area2D) -> void:
	if dead:
		return
	take_damage(1)


func take_damage(amount: int) -> void:
	if dead:
		return
	hp -= amount
	if hp <= 0:
		die()


func die() -> void:
	if dead:
		return
	dead = true
	tick.stop()
	area.monitoring = false
	hurt_box.monitoring = false
	velocity = Vector2.ZERO

	if anim and anim.sprite_frames.has_animation("death"):
		anim.play("death")
		anim.animation_finished.connect(func(): queue_free(), CONNECT_ONE_SHOT)
	else:
		queue_free()


# ---------- BOSS → PLAYER KNOCKBACK (REPEATABLE UNTIL CASTLE) ----------

func _knockback_player(player: CharacterBody2D) -> void:
	# If already in the middle of an attack/knockback, don't start another
	if is_knocking_player or dead:
		return
	# Once we start hitting castle, stop messing with player
	if attacking_castle:
		return

	is_knocking_player = true

	# attack anim
	if anim and anim.sprite_frames.has_animation("attack"):
		anim.play("attack")

	# delay before launch
	await get_tree().create_timer(PLAYER_KNOCKBACK_DELAY).timeout
	if dead or attacking_castle:
		is_knocking_player = false
		return
	if not is_instance_valid(player):
		is_knocking_player = false
		return

	# knock player up & to the right
	player.velocity.x = PLAYER_KNOCKBACK_X
	player.velocity.y = PLAYER_KNOCKBACK_Y

	# optional cooldown so he doesn't immediately retrigger while overlapping
	await get_tree().create_timer(PLAYER_KNOCKBACK_COOLDOWN).timeout

	# go back to walk if not at castle
	if not attacking_castle and anim.sprite_frames.has_animation("walk") and not dead:
		anim.play("walk")

	is_knocking_player = false
