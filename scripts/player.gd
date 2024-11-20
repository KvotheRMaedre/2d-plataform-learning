extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -350.0

@onready var animation := $anim as AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D
@onready var raycast_right := $raycast_right as RayCast2D
@onready var raycast_left := $raycast_left as RayCast2D

var player_life := 3
var knockback_vector := Vector2.ZERO
var is_jumping := false
var is_hurted := false
var direction

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
	elif is_on_floor():
		is_jumping = false
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * SPEED
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
	if player_life <= 0:
		queue_free()
	else:
		if raycast_right.is_colliding():
			take_damage(Vector2(-200,-200))
		elif raycast_left.is_colliding():
			take_damage(Vector2(200,-200))

func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path

func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	player_life -= 1
	
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		
		var knockback_tween := get_tree().create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		knockback_tween.tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color("red")
		knockback_tween.parallel().tween_property(animation, "modulate", Color(1,1,1,1), duration)
		
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
		else:
			body.break_sprite()
		body.create_coin()
