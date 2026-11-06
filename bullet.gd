extends Area2D

const SPEED = 500.0
var direction = Vector2.ZERO

func _process(delta):
	position += direction * SPEED * delta

func _on_body_entered(body):
	if body.is_in_group("Enemies"):
		body.queue_free()
		queue_free()
