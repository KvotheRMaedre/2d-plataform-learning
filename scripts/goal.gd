extends Area2D

@onready var scene_transition: Node2D = $"../scene_transition"
@onready var animation: AnimationPlayer = $animation

@export var next_level : String = ""

func _on_body_entered(body: Node2D) -> void:
	animation.play("collect")
	if body.name == "player" and next_level != "":
		scene_transition.change_scene(next_level)
