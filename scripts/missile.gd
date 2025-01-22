extends AnimatableBody2D

const SPEED := 100.0
const EXPLOSION = preload("res://prefabs/explosion.tscn")

@onready var sprite: Sprite2D = $sprite
@onready var collision: CollisionShape2D = $collision
@onready var collision_detection: CollisionShape2D = $collision_detection/collision

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
	visible = false
	collision.set_deferred("disabled", true)
	collision_detection.set_deferred("disabled", true)
	var explosion_instance = EXPLOSION.instantiate()
	get_parent().add_child(explosion_instance)
	explosion_instance.global_position = global_position
	await explosion_instance.animation_finished
	queue_free()
