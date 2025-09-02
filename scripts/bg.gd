extends AnimatedSprite2D

var rng = RandomNumberGenerator.new()
@onready var bg: AnimatedSprite2D = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bg.play("room"+str(rng.randi_range(1,3)))
