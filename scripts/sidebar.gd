extends Sprite2D
@onready var all: Sprite2D = $"."
@onready var arrow: Sprite2D = $arrow
@onready var clickarea: Area2D = $arrow/clickarea

var out = false

var start = -256
var end = -132

var start2 = 74.5
var end2 = 64.5

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if out:
		if int(all.position.x) > end-3:
			all.position.x = end
		else:
			all.position.x += (end-all.position.x)*delta*2
			
		if clickarea.panelTouchDown:
			if int(arrow.position.y) < end2-3:
				arrow.position.y = end2
			else:
				arrow.position.y += (end2-arrow.position.y)*delta*2
	else:
		if int(all.position.x) < start+3:
			all.position.x = start
		else:
			all.position.x += (start-all.position.x)*delta*2
			
		if clickarea.panelTouchDown:
			if int(arrow.position.y) > start2+3:
				arrow.position.y = start2
			else:
				arrow.position.y += (start2-arrow.position.y)*delta*2
				
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("randomMenu"):
		clickarea.panelTouchDown = true
		out = !out
