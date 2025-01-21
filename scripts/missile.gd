extends AnimatableBody2D

const SPEED := 100.0
const EXPLOSION = preload("res://prefabs/explosion.tscn")

@onready var sprite: Sprite2D = $sprite

var velocity := Vector2.ZERO
var direction

func _process(delta: float) -> void:
	velocity.x = SPEED * direction * delta
	
	move_and_collide(velocity)

func set_direction(dir) -> void:
	direction = dir
	
	if dir == 1:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func _on_collision_detection_body_entered(_body: Node2D) -> void:
	var explosion_instance = EXPLOSION.instantiate()
	get_parent().add_child(explosion_instance)
	explosion_instance.global_position = global_position
	sprite.visible = false
	await explosion_instance.animation_finished
	queue_free()
