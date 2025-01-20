extends CharacterBody2D


const SPEED = 200.0
const AIR_FRICTION := 0.5

@onready var animation := $anim as AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D
@onready var raycast_right := $raycast_right as RayCast2D
@onready var raycast_left := $raycast_left as RayCast2D
@onready var jump_sfx := $jump_sfx as AudioStreamPlayer

var knockback_vector := Vector2.ZERO
var is_jumping := false
var is_hurted := false
var direction

@export var jump_height := 64
@export var max_time_to_peak := 0.5

var jump_velocity
var gravity
var fall_gravity

signal player_has_died()

func _ready() -> void:
	jump_velocity = (jump_height * 2) / max_time_to_peak
	gravity = (jump_height * 2) / pow(max_time_to_peak, 2)
	fall_gravity = gravity * 2

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.x = 0
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -jump_velocity
		is_jumping = true
		jump_sfx.play()
	elif is_on_floor():
		is_jumping = false
		
	if velocity.y > 0 or not Input.is_action_pressed("ui_accept"):
		velocity.y += fall_gravity * delta
	else:
		velocity.y += gravity * delta
		
	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = lerp( velocity.x, direction * SPEED, AIR_FRICTION)
		animation.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
	
	_set_state()
	move_and_slide()
	
	for plataforms in get_slide_collision_count():
		var collision = get_slide_collision(plataforms)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)

func _on_hurtbox_body_entered(_body: Node2D) -> void:
	if raycast_right.is_colliding():
		take_damage(Vector2(-200,-200))
	elif raycast_left.is_colliding():
		take_damage(Vector2(200,-200))
	else:
		take_damage(Vector2(200,-200))

func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path

func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	if Globals.player_life > 0:
		Globals.player_life -= 1
	else:
		queue_free()
		emit_signal("player_has_died")
	
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		
		var knockback_tween := get_tree().create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		knockback_tween.tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color("red")
		knockback_tween.parallel().tween_property(animation, "modulate", Color(1,1,1,1), duration)
		knockback_tween.bind_node(self)
		is_hurted = true
		await get_tree().create_timer(.3).timeout
		is_hurted = false
		
func _set_state():
	var state = "idle"

	if !is_on_floor():
		state = "jump"
	elif direction != 0:
		state = "run"

	if is_hurted:
		state = "hurt"

	if animation.name != state:
		animation.play(state)

func _on_head_collider_body_entered(body: Node2D) -> void:
	if body.has_method("break_sprite"):
		if body.hitpoints >= 1:
			body.hitpoints -= 1
			body.animation.play("hit")
			body.hit_sfx.play()
		else:
			body.break_sfx.play()
			body.break_sprite()
		body.create_coin()
