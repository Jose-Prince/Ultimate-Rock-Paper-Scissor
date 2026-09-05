extends Control

var PORTRAITS := {
	GameData.CHARACTERS.ROCK: preload("res://Assets/rock.tres"),
	GameData.CHARACTERS.PAPER: preload("res://Assets/paper.tres"),
	GameData.CHARACTERS.SCISSOR: preload("res://Assets/scissor.tres"),
}
@onready var label: Label = $MarginContainer/VBoxContainer/CharSelectorContainer/Player1Container/MarginContainer/Label
@onready var label_2: Label = $MarginContainer/VBoxContainer/CharSelectorContainer/Player2Container/MarginContainer/Label2

@onready var char_1_display: TextureRect = $MarginContainer/VBoxContainer/CharSelectorContainer/Player1Container/MarginContainer/Char1Display
@onready var char_2_display: TextureRect = $MarginContainer/VBoxContainer/CharSelectorContainer/Player2Container/MarginContainer/Char2Display

@onready var timer: Timer = $Timer

var selection_finished := false


func _ready() -> void:
	randomize()

	# Los personajes todavía no se muestran
	char_1_display.hide()
	char_2_display.hide()


func _process(_delta: float) -> void:
	if selection_finished:
		return

	# Jugador 1
	if Input.is_action_just_pressed("attack_1"):
		GameData.char_player_1 = GameData.CHARACTERS.ROCK
		label.text = "READY!"

	elif Input.is_action_just_pressed("block_1"):
		GameData.char_player_1 = GameData.CHARACTERS.PAPER
		label.text = "READY!"

	elif Input.is_action_just_pressed("special_1"):
		GameData.char_player_1 = GameData.CHARACTERS.SCISSOR
		label.text = "READY!"


	# Jugador 2
	if Input.is_action_just_pressed("attack_2"):
		GameData.char_player_2 = GameData.CHARACTERS.ROCK
		label_2.text = "READY!"

	elif Input.is_action_just_pressed("block_2"):
		GameData.char_player_2 = GameData.CHARACTERS.PAPER
		label_2.text = "READY!"

	elif Input.is_action_just_pressed("special_2"):
		GameData.char_player_2 = GameData.CHARACTERS.SCISSOR
		label_2.text = "READY!"


	# Si ambos ya seleccionaron, terminar
	if GameData.char_player_1 != null and GameData.char_player_2 != null:
		timer.stop()
		_finish_selection()


func _on_timer_timeout() -> void:
	if selection_finished:
		return

	# Si un jugador no seleccionó, elegir personaje aleatorio
	if GameData.char_player_1 == null:
		GameData.char_player_1 = randi_range(
			GameData.CHARACTERS.ROCK,
			GameData.CHARACTERS.SCISSOR
		)

	if GameData.char_player_2 == null:
		GameData.char_player_2 = randi_range(
			GameData.CHARACTERS.ROCK,
			GameData.CHARACTERS.SCISSOR
		)

	_finish_selection()

func _finish_selection() -> void:
	selection_finished = true

	# Detener el timer de selección
	timer.stop()

	# Ocultar READY!
	label.hide()
	label_2.hide()

	char_1_display.texture = _portrait(GameData.char_player_1)
	char_2_display.texture = _portrait(GameData.char_player_2)
	
	# Mostrar los personajes
	char_1_display.show()
	char_2_display.show()

	# Esperar un momento antes de cambiar de escena
	await get_tree().create_timer(1.0).timeout

	# Cambiar a la batalla
	get_tree().change_scene_to_file("res://Scenes/battle_screen.tscn")

func _portrait(character) -> Texture2D:
	var data = PORTRAITS.get(character)
	if data == null or data.frames == null:
		push_warning("Sin frames para %s" % character)
		return null
	var anims = data.frames.get_animation_names()
	if anims.is_empty():
		return null
	var anim = "idle" if data.frames.has_animation("idle") else anims[0]
	return data.frames.get_frame_texture(anim, 0)
