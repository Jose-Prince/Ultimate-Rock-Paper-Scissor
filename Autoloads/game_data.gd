extends Node

enum CHARACTERS { ROCK, PAPER, SCISSOR }

const CHARACTER_DATA := {
	CHARACTERS.ROCK: preload("res://Assets/rock.tres"),
	CHARACTERS.PAPER: preload("res://Assets/paper.tres"),
	CHARACTERS.SCISSOR: preload("res://Assets/scissor.tres"),
}

var char_player_1 = null
var char_player_2 = null

func get_data(character) -> CharacterData:
	return CHARACTER_DATA.get(character)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
