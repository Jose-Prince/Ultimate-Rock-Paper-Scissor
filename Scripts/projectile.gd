extends Area2D

var direction := Vector2.RIGHT
var speed := 500.0
var damage := 10.0
var attacker


func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	



func _on_body_entered(body: Node2D) -> void:
	if body == attacker:
		return

	if body is CharacterBody2D:
		if body.is_player_1 != attacker.is_player_1:
			attacker.hit_opponent.emit(attacker, body)

	queue_free()
