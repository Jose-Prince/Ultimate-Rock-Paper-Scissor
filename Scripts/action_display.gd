@tool
extends Control

@export var button_text: String:
	set(value):
		button_text = value
		if label:
			label.text = value

@export var portrait: Texture2D:
	set(value):
		portrait = value
		if texture_rect:
			texture_rect.texture = value

@onready var label: Label = $Panel2/Label
@onready var texture_rect: TextureRect = $Panel/TextureRect

func _ready() -> void:
	label.text = button_text
	if portrait:
		texture_rect.texture = portrait
