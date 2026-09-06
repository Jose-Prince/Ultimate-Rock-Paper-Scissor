extends TextureProgressBar

@onready var timer: Timer = $"../../../Timer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_value = 100.0
	value = 100.0

func _process(delta: float) -> void:
	value = (timer.time_left / timer.wait_time) * 100.0
