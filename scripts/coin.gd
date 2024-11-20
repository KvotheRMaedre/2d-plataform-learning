extends Area2D

var coins_value := 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_body_entered(_body: Node2D) -> void:
	$anime.play("collect")
	await $collision.call_deferred("queue_free")
	Globals.coins += coins_value

func _on_anime_animation_finished() -> void:
	if $anime.animation == "collect":
		queue_free()
