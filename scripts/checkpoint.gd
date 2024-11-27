extends Area2D

@onready var anim: AnimatedSprite2D = $anim
@onready var respawn_position: Marker2D = $respawn_position

var is_active = false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player" && !is_active:
		is_active = true
		anim.play("raising")


func _on_anim_animation_finished() -> void:
	if anim.animation == "raising":
		anim.play("checked")
		Globals.current_checkpoint = respawn_position
		
