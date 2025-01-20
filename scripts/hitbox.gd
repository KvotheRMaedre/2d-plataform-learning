extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		get_parent().anim.play("hurt")
		body.velocity.y = -body.jump_velocity
