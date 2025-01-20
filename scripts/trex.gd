extends CharacterBody2D

const FIREBALL = preload("res://prefabs/fireball.tscn")

@onready var sprite: Sprite2D = $sprite
@onready var hurt_sprite: Sprite2D = $sprite/hurt_sprite
@onready var fireball_spawm_point: Marker2D = $fireball_spawm_point
@onready var ground_detector: RayCast2D = $ground_detector
@onready var player_detector: RayCast2D = $player_detector
@onready var anim: AnimationPlayer = $anim

var move_spped := 50.0
var direction := 1
var health_points := 3
@export var score_points := 300

enum EnemyState {PATROL, ATTACK, HURT}
var current_state = EnemyState.PATROL
@export var target : CharacterBody2D

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(_delta: float) -> void:
	match(current_state):
		EnemyState.PATROL : patrol_state()
		EnemyState.ATTACK : attack_state()

func patrol_state():
	anim.play("run")
	if is_on_wall() || !ground_detector.is_colliding():
		direction *= -1
		sprite.scale.x *= -1
		player_detector.scale.x *= -1
		fireball_spawm_point.position.x *= -1
	
	velocity.x = direction * move_spped
	
	if player_detector.is_colliding():
		_change_state(EnemyState.ATTACK)
	
	move_and_slide()

func attack_state():
	anim.play("shoot")
	
	if !player_detector.is_colliding():
		_change_state(EnemyState.PATROL)

func hurt_state():
	anim.play("hurt")
	hurt_sprite.visible = true
	await anim.animation_finished
	
	health_points -= 1
	if health_points == 0:
		queue_free()
		Globals.score += score_points
	
	hurt_sprite.visible = false
	_change_state(EnemyState.PATROL)

func _change_state(state):
	current_state = state

func spawm_fireball():
	var new_fireball = FIREBALL.instantiate()
	
	if sign(fireball_spawm_point.position.x) == 1:
		new_fireball.set_direction(1)
	else:
		new_fireball.set_direction(-1)
	
	new_fireball.global_position = fireball_spawm_point.global_position
	add_sibling(new_fireball)

func _on_hitbox_body_entered(_body: Node2D) -> void:
	_change_state(EnemyState.HURT)
	hurt_state()
