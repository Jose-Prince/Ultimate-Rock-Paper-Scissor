extends Control

@onready var label: Label = $MarginContainer/VBoxContainer/CharSelectorContainer/Player1Container/MarginContainer/Label
@onready var label_2: Label = $MarginContainer/VBoxContainer/CharSelectorContainer/Player2Container/MarginContainer/Label2


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	# Jugador 1
	if Input.is_action_just_pressed("attack_1") \
	or Input.is_action_just_pressed("block_1") \
	or Input.is_action_just_pressed("special_1"):
		label.text = "READY!"

	# Jugador 2
	if Input.is_action_just_pressed("attack_2") \
	or Input.is_action_just_pressed("block_2") \
	or Input.is_action_just_pressed("special_2"):
		label_2.text = "READY!"


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/battle_screen.tscn")
