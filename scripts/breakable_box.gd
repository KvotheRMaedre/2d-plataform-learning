extends CharacterBody2D

const box_piecies = preload("res://prefabs/box_pieces.tscn")
const coin_instance = preload("res://prefabs/coin_rigid.tscn")

@onready var texture := $texture as Sprite2D
@onready var animation := $anim as AnimationPlayer
@onready var spawn_coin := $spawn_coin as Marker2D
@onready var break_sfx := $break_sfx as AudioStreamPlayer
@onready var hit_sfx := $hit_sfx as AudioStreamPlayer
@onready var collision: CollisionShape2D = $collision

@export var pieces : PackedStringArray
@export var hitpoints := 3

var impulse := 200

func break_sprite():
	for piece in pieces.size():
		var piece_instance = box_piecies.instantiate()
		get_parent().add_child(piece_instance)
		piece_instance.get_node("texture").texture = load(pieces[piece])
		piece_instance.global_position = global_position
		piece_instance.apply_impulse(Vector2(randi_range(-impulse,impulse),randi_range(-impulse, -impulse * 2)))
	texture.visible = false
	collision.queue_free()
	await break_sfx.finished
	queue_free()

func create_coin():
	var coin = coin_instance.instantiate()
	get_parent().call_deferred("add_child", coin)
	coin.global_position = spawn_coin.global_position
	coin.apply_impulse(Vector2(randi_range(-50,50), -150))
