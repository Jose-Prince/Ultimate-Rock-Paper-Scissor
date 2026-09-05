extends CharacterBody2D

const GRAVITY := 1200.0
const JUMP_FORCE := -500.0

@export var speed: float = 400.0
@export var is_player_1: bool

func _physics_process(delta: float) -> void:
	var input_direction
	
	if is_player_1:
		input_direction = Input.get_axis("left", "right")
		
		if Input.is_action_just_pressed("up") and is_on_floor():
			velocity.y = JUMP_FORCE
	else:
		input_direction = Input.get_axis("ui_left", "ui_right")
		
		if Input.is_action_just_pressed("ui_up") and is_on_floor():
			velocity.y = JUMP_FORCE

	velocity.x = input_direction * speed
	
	if !is_on_floor():
		velocity.y += GRAVITY * delta
	
	move_and_slide()
