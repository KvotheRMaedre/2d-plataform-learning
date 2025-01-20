extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $anim

var move_speed := 50.0
var direction := 1

func _process(delta: float) -> void:
	position.x += move_speed * direction * delta
	
func set_direction(dir):
	direction = dir
	if dir < 0:
		$anim.flip_h =  true
	else:
		$anim.flip_h = false
