extends Node2D

@onready var player := $player as CharacterBody2D
@onready var camera := $camera as Camera2D
@onready var control: Control = $HUD/control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.follow_camera(camera)
	player.player_has_died.connect(reload_game)
	control.time_is_up.connect(reload_game)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func reload_game():
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()
	Globals.reset()
