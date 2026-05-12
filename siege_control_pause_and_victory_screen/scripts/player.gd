extends CharacterBody2D

@export var SPEED: float = 100.0
@export var JUMP_VELOCITY: float = -350.0
@export var ATTACK_DAMAGE: int = 10
@export var ATTACK_DELAY: float = 0.50
@export var ATTACK_COOLDOWN: float = 0.4
@export var attacking_sound: AudioStreamPlayer2D = null
@export var blockhit_sound: AudioStreamPlayer2D = null
@export var jumping_soound : AudioStreamPlayer2D = null

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var atk: Area2D = $AttackArea

var g: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_attacking := false
var can_attack := true
var is_blocking := false
var can_block := true

func _ready() -> void:
	if not atk.is_connected("area_entered", _on_attack_hit_area):
		atk.area_entered.connect(_on_attack_hit_area)
	if not anim.is_connected("animation_finished", _on_anim_finished):
		anim.animation_finished.connect(_on_anim_finished)
	var sf := anim.sprite_frames
	if sf and sf.has_animation("attack"):
		sf.set_animation_loop("attack", false)
	atk.collision_layer = 0
	atk.collision_mask = 0
	atk.set_collision_mask_value(6, true) # listens to slime hurt_box layer
	atk.monitoring = false
	atk.monitorable = true

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += g * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$jumping_sound.play()
	var dir := Input.get_axis("move_left", "move_right")
	if dir != 0.0:
		velocity.x = dir * SPEED
		anim.flip_h = dir < 0.0
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)
	move_and_slide()
	if Input.is_action_just_pressed("attack") and can_attack and not is_attacking:
		start_attack()
		$attacking_sound.play()
	if not is_attacking:
		if not is_on_floor():
			if anim.animation != "jump": anim.play("jump")
		elif abs(velocity.x) > 1.0:
			if anim.animation != "walk": anim.play("walk")
		else:
			if anim.animation != "idle": anim.play("idle")
		# Example: hold "block" action
	if Input.is_action_pressed("block") and can_block:
		is_blocking = true
		if anim.animation != "block":
			anim.play("block")
	else:
		is_blocking = false
		if anim.animation == "block":
			anim.play("idle")  # return to idle if not moving


func start_attack() -> void:
	is_attacking = true
	can_attack = false
	anim.play("attack")
	await get_tree().create_timer(ATTACK_DELAY).timeout
	atk.monitoring = true
	await get_tree().create_timer(0.1).timeout
	atk.monitoring = false
	await get_tree().create_timer(ATTACK_COOLDOWN).timeout
	can_attack = true
	
func take_damage(_amount: int) -> void:
	if is_blocking:
		if blockhit_sound:
			blockhit_sound.play()  # play the block sound directly
		if anim and anim.sprite_frames.has_animation("block"):
			anim.play("block")
	else:
		if attacking_sound:
			attacking_sound.play()  # play the hit sound


func _on_anim_finished() -> void:
	if anim.animation == "attack":
		is_attacking = false

func _on_attack_hit_area(a: Area2D) -> void:
	if not is_attacking:
		return
	var target := a.get_parent()
	if target and target.has_method("take_damage"):
		target.take_damage(ATTACK_DAMAGE)

func increase_damage(amount: int) -> void:
	ATTACK_DAMAGE += amount
	print("Player damage increased to:", ATTACK_DAMAGE)
	
