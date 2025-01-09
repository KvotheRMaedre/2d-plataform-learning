extends Node2D

@onready var anim: AnimationPlayer = $anim
@onready var bg: ColorRect = $bg

func _ready():
	show_new_scene()

func change_scene(path: StringName):
	anim.play("fade")
	await anim.animation_finished
	assert(get_tree().change_scene_to_file(path) == OK)

func show_new_scene():
	anim.play("fade_out")
