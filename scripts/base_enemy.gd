extends CharacterBody2D
class_name BaseEnemy

const SPEED = 700.0
const JUMP_VELOCITY = -400.0

@export var enemy_points := 100
@onready var anim := $anim

var wall_detector
var texture
var direction := -1

var can_spawn = false
var spawn_instance : PackedScene = null
var spawn_instance_position

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func flip_direction():
	if wall_detector.is_colliding():
		direction *= -1 
		texture.scale.x *= -1
		wall_detector.scale.x *= -1

func movement(delta: float) -> void:
	velocity.x = direction * SPEED * delta
	move_and_slide()

func kill_and_score():
	if can_spawn:
		spawn_new_enemy()
		get_parent().queue_free()
	else:
		queue_free()
	Globals.score += enemy_points

func kill_ground_enemy(anim_name: StringName) -> void:
	if anim_name == "hurt":
		kill_and_score()

func kill_air_enemy() -> void:
		kill_and_score()

func spawn_new_enemy() -> void:
	var instance_scene = spawn_instance.instantiate()
	get_tree().root.add_child(instance_scene)
	instance_scene.global_position = spawn_instance_position.global_position
	
