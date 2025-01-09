extends Node2D

@onready var anim: AnimationPlayer = $anim

func _ready():
	show_new_scene()

func change_scene(path: StringName):
	anim.play("fade_in")
	await get_tree().create_timer(1).timeout
	assert(get_tree().change_scene_to_file(path) == OK)

func show_new_scene():
	anim.play("fade_out")
