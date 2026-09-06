extends Node2D

const ROCK_SCENE = preload("uid://tandcb2ius0a")
const PAPER_SCENE = preload("uid://bffby2cindog0")
const SCISSOR_SCENE = preload("uid://bayhut60dc20h")

var player1
var player2

@onready var spawn_player_1: Marker2D = $SpawnPlayer1
@onready var spawn_player_2: Marker2D = $SpawnPlayer2


func _ready() -> void:
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
	# Si no hay personaje seleccionado, no generar nada
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

	# Indicar si pertenece al jugador 1
	instance.is_player_1 = is_player_1

	add_child(instance)

	instance.global_position = spawn.global_position

	return instance
