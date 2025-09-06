extends Sprite2D
@onready var all: Sprite2D = $"."
@onready var mouse: Node2D = $"../../mouse"
@onready var icon: Sprite2D = $icon
@onready var time: Label = $Label


#main gui bg vars
var goDown = false
var start = -256
var end = -132
# -

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if goDown:
		if int(all.position.y) > end-3:
			all.position.y = end
		else:
			all.position.y += (end-all.position.y)*delta*2
	else:
		if int(all.position.y) < start+3:
			all.position.y = start
		else:
			all.position.y += (start-all.position.y)*delta*2
	
	# Directly based off of the original PTM Python code
	var source = mouse.aliveTime
	var minutes = int(int(source) / 60)
	var seconds = int(int(source) % 60)
	#---
	var format_string = "Time alive: %s:%s"
	time.text = format_string%["%02d" % minutes,"%02d" % seconds]
	
	var beat = 0.5 + (int(mouse.aliveTime*1.5)%2)*0.1
	icon.scale = Vector2(beat,beat)

func _input(event):
	if event.is_action_pressed("left"):
		goDown = !goDown
