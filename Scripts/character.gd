extends CharacterBody2D

signal hit_opponent(attacker, opponent)
const PROJECTILE_SCENE = preload("res://Prefabs/projectile.tscn")
const GRAVITY := 2000.0
const JUMP_FORCE := -200.0

const MAX_SHIELD_ENERGY := 100.0
const SHIELD_DRAIN := 35.0
const SHIELD_REGEN := 25.0

@export var stats: CharacterStats
@export var is_player_1: bool
@export var character_type: GameData.CHARACTERS
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_zone: Area2D = $AttackZone
@onready var shield: Sprite2D = $Shield

var is_attacking := false
var is_blocking := false

var attack_zone_x: float
var has_hit := false

var current_health: float
var attack_damage: float
var speed: float = 150.0

var shield_energy := MAX_SHIELD_ENERGY

var next_attack := "punch"


func _ready() -> void:
	if stats:
		current_health = stats.health
		attack_damage = stats.attack
		speed = stats.speed
	else:
		push_warning("No CharacterStats assigned to %s" % name)

	attack_zone_x = abs(attack_zone.position.x)

	shield.hide()

	sprite.animation_finished.connect(_on_animation_finished)
	sprite.play("idle")


func _physics_process(delta: float) -> void:
	var prefix := "" if is_player_1 else "ui_"

	var input_direction := Input.get_axis(
		prefix + "left",
		prefix + "right"
	)

	# ESCUDO
	_handle_shield(delta)

	# ATAQUES
	if not is_attacking and not is_blocking and is_on_floor():
		if is_player_1:
			if Input.is_action_just_pressed("attack_1"):
				_start_attack(next_attack)
		else:
			if Input.is_action_just_pressed("attack_2"):
				_start_attack(next_attack)

	# SALTO
	if Input.is_action_just_pressed(prefix + "up") \
	and is_on_floor() \
	and not is_attacking \
	and not is_blocking:
		velocity.y = JUMP_FORCE

	# MOVIMIENTO
	if is_attacking or is_blocking:
		velocity.x = 0.0
	else:
		velocity.x = input_direction * speed

	# GRAVEDAD
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	move_and_slide()

	_update_animation(input_direction)

	# COMPROBAR GOLPE
	if is_attacking and not has_hit:
		_check_attack_hit()
		
	# ESPECIAL
	#if not is_attacking and not is_blocking and is_on_floor():
		#if is_player_1:
			#if Input.is_action_just_pressed("special_1"):
				#_use_special()
	#else:
		#if Input.is_action_just_pressed("special_2"):
			#_use_special()

#func _use_special() -> void:
	#if character_type != GameData.CHARACTERS.SCISSOR:
		#return
#
	#var projectile = PROJECTILE_SCENE.instantiate()
#
	#projectile.attacker = self
	#projectile.damage = attack_damage
#
	#if sprite.flip_h:
		#projectile.direction = Vector2.LEFT
	#else:
		#projectile.direction = Vector2.RIGHT
#
	#get_parent().add_child(projectile)
#
	#projectile.global_position = global_position
	#projectile.global_position.x += 30.0 if not sprite.flip_h else -30.0

func _handle_shield(delta: float) -> void:
	var shield_action := "block_1" if is_player_1 else "block_2"

	var shield_pressed := Input.is_action_pressed(shield_action)

	# Activar escudo
	if shield_pressed and shield_energy > 0.0 and not is_attacking:
		is_blocking = true
		shield.show()

		shield_energy -= SHIELD_DRAIN * delta

		# Se quedó sin energía
		if shield_energy <= 0.0:
			shield_energy = 0.0
			is_blocking = false
			shield.hide()

	else:
		is_blocking = false
		shield.hide()

		# Regenerar energía
		shield_energy += SHIELD_REGEN * delta
		shield_energy = min(shield_energy, MAX_SHIELD_ENERGY)


func _start_attack(anim: String) -> void:
	is_attacking = true
	has_hit = false

	sprite.play(anim)


func _check_attack_hit() -> void:
	var bodies := attack_zone.get_overlapping_bodies()

	for body in bodies:
		if body == self:
			continue

		if body is CharacterBody2D:
			if body.is_player_1 != is_player_1:

				# Si el oponente tiene escudo,
				# el ataque no hace daño.
				if body.is_blocking:
					has_hit = true
					break

				has_hit = true

				hit_opponent.emit(self, body)

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

	if is_blocking:
		_play("idle")
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
