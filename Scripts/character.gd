extends CharacterBody2D

signal hit_opponent(opponent)

const GRAVITY := 2000.0
const JUMP_FORCE := -200.0

@export var speed: float = 150.0
@export var is_player_1: bool

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_zone: Area2D = $AttackZone

var is_attacking := false
var attack_zone_x: float
var has_hit := false

var next_attack := "punch"


func _ready() -> void:
	attack_zone_x = abs(attack_zone.position.x)

	sprite.animation_finished.connect(_on_animation_finished)
	sprite.play("idle")


func _physics_process(delta: float) -> void:
	var prefix := "" if is_player_1 else "ui_"
	var input_direction := Input.get_axis(prefix + "left", prefix + "right")

	# ATAQUES
	if not is_attacking and is_on_floor():
		if is_player_1:
			if Input.is_action_just_pressed("attack_1"):
				_start_attack(next_attack)
			elif Input.is_action_just_pressed("block_1"):
				_start_attack(next_attack)
		else:
			if Input.is_action_just_pressed("attack_2"):
				_start_attack(next_attack)
			elif Input.is_action_just_pressed("block_2"):
				_start_attack(next_attack)

	# SALTO
	if Input.is_action_just_pressed(prefix + "up") and is_on_floor() and not is_attacking:
		velocity.y = JUMP_FORCE

	# MOVIMIENTO
	velocity.x = 0.0 if is_attacking else input_direction * speed

	if !is_on_floor():
		velocity.y += GRAVITY * delta

	move_and_slide()
	_update_animation(input_direction)

	# Comprobar si golpeamos al oponente
	if is_attacking and not has_hit:
		_check_attack_hit()


func _start_attack(anim: String) -> void:
	is_attacking = true
	has_hit = false
	sprite.play(anim)


func _check_attack_hit() -> void:
	var bodies := attack_zone.get_overlapping_bodies()

	for body in bodies:
		if body == self:
			continue

		# Solo golpear al otro jugador
		if body is CharacterBody2D:
			if body.is_player_1 != is_player_1:
				has_hit = true

				# Avisar que golpeamos
				hit_opponent.emit(body)

				# Cambiar el siguiente ataque
				if next_attack == "punch":
					next_attack = "kick"
				else:
					next_attack = "punch"

				break


func _on_animation_finished() -> void:
	if sprite.animation in ["punch", "kick"]:
		is_attacking = false
		has_hit = false


func _update_animation(dir: float) -> void:
	if is_attacking:
		return

	if not is_on_floor():
		_play("jump")

	elif dir != 0.0:
		_play("run_right")

		sprite.flip_h = dir < 0.0

		if dir < 0.0:
			attack_zone.position.x = -attack_zone_x
		else:
			attack_zone.position.x = attack_zone_x

	else:
		_play("idle")


func _play(anim: String) -> void:
	if sprite.animation != anim:
		sprite.play(anim)
