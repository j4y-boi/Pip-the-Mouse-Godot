extends Sprite2D
@onready var all: Sprite2D = $"."
@onready var mouse: Node2D = $"../../mouse"
@onready var icon: Sprite2D = $icon
@onready var time: Label = $Label
@onready var arrow: Sprite2D = $arrow

#main gui bg vars
var goDown = false
var start = -256
var end = -132

var slidelimit = 2

const foodTextures = [
	"res://assets/food/apple_slice.bmp",
	"res://assets/food/cheese.bmp",
	"res://assets/food/grapes.bmp",
	"res://assets/food/peanut.bmp"
]

var textured = load("res://assets/gui/heart.png")

var topguislide = 0

var start2 = 74.5
var end2 = 64.5
# -

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if goDown:
		if int(all.position.y) > end-3:
			all.position.y = end
		else:
			all.position.y += (end-all.position.y)*delta*2
			
		if int(arrow.position.y) < end2-3:
			arrow.position.y = end2
		else:
			arrow.position.y += (end2-arrow.position.y)*delta*2
	else:
		if int(all.position.y) < start+3:
			all.position.y = start
		else:
			all.position.y += (start-all.position.y)*delta*2
			
		if int(arrow.position.y) > start2+3:
			arrow.position.y = start2
		else:
			arrow.position.y += (start2-arrow.position.y)*delta*2
	
	# Directly based off of the original PTM Python code
	var source
	if topguislide == 0:
		source = mouse.aliveTime
	elif topguislide == 1:
		source = mouse.feedTimeLeft
	
	var minutes = int(int(source) / 60)
	var seconds = int(int(source) % 60)
	#---
	if topguislide == 0:
		var format_string = "Time alive: %s:%s"
		time.text = format_string%["%02d" % minutes,"%02d" % seconds]
		var beat = 0.5 + (int(mouse.aliveTime*1.5)%2)*0.1
		icon.texture = textured
		icon.rotation = 0
		icon.scale = Vector2(beat,beat)
	if topguislide == 1:
		var format_string = "Hungry in: %s:%s"
		time.text = format_string%["%02d" % minutes,"%02d" % seconds]
		var beat = -0.5+(int(mouse.aliveTime)%2)*1
		icon.scale = 0.8
		icon.texture = textured
		icon.rotation = beat
	#if topguislide == 2: #adding later
		#var format_string = "Time alive: %s:%s"
		#time.text = format_string%["%02d" % minutes,"%02d" % seconds]
		#var beat = 0.5 + (int(mouse.aliveTime*1.5)%2)*0.1
		#icon.scale = Vector2(beat,beat)

func _input(event):
	if event.is_action_pressed("down"):
		goDown = !goDown
	
	var ableToChange = goDown and not mouse.dead
	
	if event.is_action_pressed("left") and ableToChange:
		topguislide = (topguislide - 1 + slidelimit) % slidelimit  #this way itll loop back to 0 when 2+1, i am NOT doing any if statements today
		if topguislide == 0:
			textured = load("res://assets/gui/heart.png")
		elif topguislide == 1:
			textured = load(foodTextures[randi_range(0,len(foodTextures)-1)])
	if event.is_action_pressed("right") and ableToChange:
		topguislide = (topguislide + 1) % slidelimit
		if topguislide == 0:
			textured = load("res://assets/gui/heart.png")
		elif topguislide == 1:
			textured = load(foodTextures[randi_range(0,len(foodTextures)-1)])
		
