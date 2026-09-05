extends Label

var is_visible := true

@onready var blink_timer: Timer = $"../../BlinkTimer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = is_visible
	blink_timer.start()


func _on_blink_timer_timeout() -> void:
	is_visible = !is_visible
	visible = is_visible
