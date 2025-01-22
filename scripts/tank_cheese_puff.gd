extends CharacterBody2D

const MISSILE := preload("res://prefabs/missile.tscn")
const BOMB := preload("res://prefabs/bomb.tscn")
const SPEED = 5000.0

@onready var wall_detector = $wall_detector
@onready var sprite: Sprite2D = $sprite
@onready var missile_spawn_point: Marker2D = %missile_spawn_point
@onready var bomb_spawn_point: Marker2D = %bomb_spawn_point

var direction = -1

func _physics_process(delta: float) -> void:
	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1
	
	if direction == 1:
		velocity.x = SPEED * delta
		sprite.flip_h = true
	else:
		velocity.x = -SPEED * delta
		sprite.flip_h = false
	move_and_slide()

func trow_bomb():
	var bomb_instance =  BOMB.instantiate()
	add_sibling(bomb_instance)
	bomb_instance.global_position = bomb_spawn_point.global_position
	bomb_instance.apply_impulse(Vector2(randi_range(direction * 30, direction * 200), randi_range(-200,-400)))

func launch_missile():
	var missile_instance = MISSILE.instantiate()
	add_sibling(missile_instance)
	missile_instance.global_position = missile_spawn_point.global_position
	missile_instance.set_direction(direction)

func _on_bomb_cooldown_timeout() -> void:
	trow_bomb()

func _on_missile_cooldown_timeout() -> void:
	launch_missile()
