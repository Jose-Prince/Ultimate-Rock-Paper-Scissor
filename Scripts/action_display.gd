extends Control

@export var button_text: String

@onready var label: Label = $Panel2/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = button_text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
