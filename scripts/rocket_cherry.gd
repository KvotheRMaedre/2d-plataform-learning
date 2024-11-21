extends CharacterBody2D

@onready var anime: AnimatedSprite2D = $anime

@export var enemy_score := 100

func _on_hitbox_body_entered(body: Node2D) -> void:
	anime.play("hurt")

func _on_anime_animation_finished() -> void:
	if anime.animation == "hurt":
		queue_free()
		Globals.score += enemy_score
