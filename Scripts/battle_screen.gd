extends Node2D

const ROCK_SCENE = preload("uid://tandcb2ius0a")
const PAPER_SCENE = preload("uid://bffby2cindog0")
const SCISSOR_SCENE = preload("uid://bayhut60dc20h")

const DAMAGE := 10.0

var player1
var player2
var game_over := false

@onready var spawn_player_1: Marker2D = $SpawnPlayer1
@onready var spawn_player_2: Marker2D = $SpawnPlayer2

@onready var winner: Label = $Winner

@onready var health_player_1: TextureProgressBar = $HealthPlayer1
@onready var health_player_2: TextureProgressBar = $HealthPlayer2
@onready var shield_player_1: TextureProgressBar = $ShieldPlayer1
@onready var shield_player_2: TextureProgressBar = $ShieldPlayer2

func _ready() -> void:
	winner.hide()

	player1 = _spawn_character(
		GameData.char_player_1,
		spawn_player_1,
		true
	)

	player2 = _spawn_character(
		GameData.char_player_2,
		spawn_player_2,
		false
	)


func _spawn_character(character, spawn: Marker2D, is_player_1: bool):
	if character == null:
		return null

	var scene

	match character:
		GameData.CHARACTERS.ROCK:
			scene = ROCK_SCENE

		GameData.CHARACTERS.PAPER:
			scene = PAPER_SCENE

		GameData.CHARACTERS.SCISSOR:
			scene = SCISSOR_SCENE

		_:
			return null

	var instance = scene.instantiate()

	instance.is_player_1 = is_player_1

	add_child(instance)

	instance.global_position = spawn.global_position

	instance.hit_opponent.connect(_on_player_hit)

	return instance


func _on_player_hit(attacker, opponent) -> void:
	if game_over:
		return

	opponent.current_health -= attacker.attack_damage

	if opponent == player1:
		health_player_1.value = opponent.current_health

	elif opponent == player2:
		health_player_2.value = opponent.current_health

	_check_winner()

func _check_winner() -> void:
	if player1.current_health <= 0:
		_end_game(2)

	elif player2.current_health <= 0:
		_end_game(1)
		
func _end_game(winning_player: int) -> void:
	if game_over:
		return

	game_over = true

	# Mostrar ganador
	winner.text = "PLAYER %d WINS!" % winning_player
	winner.show()

	# Desactivar a los jugadores
	if player1:
		player1.set_physics_process(false)

	if player2:
		player2.set_physics_process(false)

	# Esperar 3 segundos
	await get_tree().create_timer(3.0).timeout

	# Volver a la pantalla de inicio
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
