extends RigidBody2D

const EXPLOSION = preload("res://prefabs/explosion.tscn")
@onready var sprite: Sprite2D = $sprite

func _on_body_entered(_body: Node) -> void:
	var explosion_instance = EXPLOSION.instantiate()
	get_parent().add_child(explosion_instance)
	explosion_instance.global_position = global_position
	sprite.visible = false
	await explosion_instance.animation_finished
	queue_free()
