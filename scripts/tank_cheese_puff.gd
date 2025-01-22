extends CharacterBody2D

const MISSILE := preload("res://prefabs/missile.tscn")
const BOMB := preload("res://prefabs/bomb.tscn")
const SPEED = 5000.0

@onready var wall_detector = $wall_detector
@onready var sprite: Sprite2D = $sprite
@onready var missile_spawn_point: Marker2D = %missile_spawn_point
@onready var bomb_spawn_point: Marker2D = %bomb_spawn_point
@onready var anim_tree: AnimationTree = $anim_tree
@onready var state_machine = anim_tree["parameters/playback"]

var direction = -1

#Flags
var turn_count := 0
var missile_count := 0
var bomb_count := 0
var can_launch_missile := true
var can_throw_bomb := true
var got_hit := false

func _ready() -> void:
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1
		turn_count += 1
	
	match state_machine.get_current_node():
		"patrol":
			$hurtbox/collision_hurtbox.set_deferred("disabled", true)
			if direction == 1:
				velocity.x = SPEED * delta
				sprite.flip_h = true
			else:
				velocity.x = -SPEED * delta
				sprite.flip_h = false
			move_and_slide()
		"missile_attack":
			velocity.x = 0
			await get_tree().create_timer(2.0).timeout
			
			if can_launch_missile:
				launch_missile()
				can_launch_missile = false
		"hide_bomb":
			velocity.x = 0
			await get_tree().create_timer(2.0).timeout
			
			if can_throw_bomb:
				throw_bomb()
				can_throw_bomb = false
		"vulnerable":
			can_launch_missile = false
			can_throw_bomb = false
			await get_tree().create_timer(2.0).timeout
			got_hit = false
			$hurtbox/collision_hurtbox.set_deferred("disabled", false)
	
	if turn_count <= 2:
		anim_tree.set("parameters/conditions/can_move", true)
		anim_tree.set("parameters/conditions/time_missile", false)
	elif missile_count >= 4:
		anim_tree.set("parameters/conditions/time_bomb", true)
		missile_count = 0
	elif bomb_count >= 3:
		anim_tree.set("parameters/conditions/is_vulnerable", true)
		bomb_count = 0
	else:
		anim_tree.set("parameters/conditions/can_move", false)
		anim_tree.set("parameters/conditions/is_vulnerable", false)
		anim_tree.set("parameters/conditions/time_bomb", false)
		anim_tree.set("parameters/conditions/time_missile", true)

func throw_bomb():
	if bomb_count <= 3:
		var bomb_instance =  BOMB.instantiate()
		add_sibling(bomb_instance)
		bomb_instance.global_position = bomb_spawn_point.global_position
		bomb_instance.apply_impulse(Vector2(randi_range(direction * 30, direction * 300), randi_range(-200,-400)))
		$bomb_cooldown.start()
		bomb_count += 1

func launch_missile():
	if missile_count <= 4:
		var missile_instance = MISSILE.instantiate()
		add_sibling(missile_instance)
		missile_instance.global_position = missile_spawn_point.global_position
		missile_instance.set_direction(direction)
		$missile_cooldown.start()
		missile_count += 1

func _on_bomb_cooldown_timeout() -> void:
	can_throw_bomb = true

func _on_missile_cooldown_timeout() -> void:
	can_launch_missile = true

func _on_player_detection_body_entered(_body: Node2D) -> void:
	set_physics_process(true)

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	set_physics_process(true)

func _on_hurtbox_body_entered(body: Node2D) -> void:
	body.velocity = Vector2(50,-300)
	got_hit = true
	turn_count = 0
