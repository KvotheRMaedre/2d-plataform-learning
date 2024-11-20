extends Control

@onready var coins_counter: Label = $container/coins_container/coins_counter
@onready var score_counter: Label = $container/score_container/score_counter
@onready var timer_counter: Label = $container/timer_container/timer_counter
@onready var life_counter: Label = $container/life_container/life_counter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coins_counter.text = str("%04d" % Globals.coins)
	score_counter.text = str("%06d" % Globals.score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	coins_counter.text = str("%04d" % Globals.coins)
	score_counter.text = str("%06d" % Globals.score)
