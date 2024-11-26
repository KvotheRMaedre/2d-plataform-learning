extends BaseEnemy

@onready var spawm_enemy: Marker2D = $"../spawm_enemy"

func _ready() -> void:
	spawn_instance = preload("res://actors/cherry.tscn")
	spawn_instance_position = spawm_enemy
	can_spawn = true
	anim.animation_finished.connect(kill_air_enemy)

func _on_hitbox_body_entered(body: Node2D) -> void:
	anim.play("hurt")
