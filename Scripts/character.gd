extends CharacterBody2D

const GRAVITY := 1900.0
const JUMP_FORCE := -500.0

@export var speed: float = 150.0
@export var is_player_1: bool

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var frames: SpriteFrames
var is_attacking := false

func _ready() -> void:
	if frames:
		sprite.sprite_frames = frames
	sprite.animation_finished.connect(_on_animation_finished)
	sprite.play("idle")

func _physics_process(delta: float) -> void:
	var prefix := "" if is_player_1 else "ui_"
	var input_direction := Input.get_axis(prefix + "left", prefix + "right")

	if not is_attacking and is_on_floor():
		if Input.is_action_just_pressed(prefix + "punch"):
			_start_attack("punch")
		elif Input.is_action_just_pressed(prefix + "kick"):
			_start_attack("kick")

	if Input.is_action_just_pressed(prefix + "up") and is_on_floor() and not is_attacking:
		velocity.y = JUMP_FORCE

	velocity.x = 0.0 if is_attacking else input_direction * speed

	if !is_on_floor():
		velocity.y += GRAVITY * delta

	move_and_slide()
	_update_animation(input_direction)


func _start_attack(anim: String) -> void:
	is_attacking = true
	sprite.play(anim)


func _on_animation_finished() -> void:
	if sprite.animation in ["punch", "kick"]:
		is_attacking = false


func _update_animation(dir: float) -> void:
	if is_attacking:
		return

	if not is_on_floor():
		_play("jump")
	elif dir != 0.0:
		_play("run_right")
		sprite.flip_h = dir < 0.0
	else:
		_play("idle")


func _play(anim: String) -> void:
	if sprite.animation != anim:
		sprite.play(anim)
