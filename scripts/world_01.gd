extends Node2D

@onready var player := $player as CharacterBody2D
@onready var player_scene = preload("res://actors/player.tscn")
@onready var camera := $camera as Camera2D
@onready var control: Control = $HUD/control
@onready var start_player_position: Marker2D = $start_player_position
@onready var scene_transition: Node2D = $scene_transition
@onready var bg_music: AudioStreamPlayer = $bg_music

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene_transition.bg.color.a = 255
	Globals.start_position = start_player_position
	Globals.player = player
	Globals.player.follow_camera(camera)
	Globals.player.player_has_died.connect(reload_game)
	control.time_is_up.connect(game_over)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func reload_game():
	await get_tree().create_timer(1.0).timeout
	control.reset_clock()
	player = player_scene.instantiate()
	add_child(player)
	Globals.player = player
	Globals.player.follow_camera(camera)
	Globals.player.player_has_died.connect(reload_game)
	Globals.respawn_player()

func game_over() -> void:
	Globals.reset()
	get_tree().change_scene_to_file("res://scene/game_over.tscn")
