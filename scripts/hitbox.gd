extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		owner.anime.play("hurt")
		body.velocity.y = body.JUMP_VELOCITY
