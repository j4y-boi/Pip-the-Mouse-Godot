extends Sprite2D
@onready var logo: Sprite2D = $"."

var start = -95
var end = 100
var time = 0.0

func _ready() -> void:
	logo.position.y = start

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	
	logo.rotation = (sin(time))/10
	
	if int(logo.position.y) > end-3:
		logo.position.y = end
	else:
		logo.position.y += (end-logo.position.y)*delta*2
