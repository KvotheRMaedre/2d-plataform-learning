extends Area2D

@onready var collision: CollisionShape2D = $collision
@onready var texture: Sprite2D = $texture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision.shape.size = texture.get_rect().size


func _on_body_entered(body: Node2D):
	if body.name == "player" && body.has_method("take_damage"):
		body.take_damage(Vector2(0,-200))
