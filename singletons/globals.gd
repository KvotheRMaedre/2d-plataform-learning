extends Node

var coins := 0
var score := 0
var player_life := 3

var player = null
var current_checkpoint = null

func reset() -> void:
	coins = 0
	score = 0
	player_life = 3

func respawn_player() -> void:
	Globals.reset()
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position
