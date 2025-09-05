extends Node2D
@onready var mouse: Node2D = $"."
@onready var mouseSprite: AnimatedSprite2D = $sprite
@onready var eventTimer: Timer = $event
@onready var save: Node = %Save

var aliveTime = 0.0
var consecutiveEvents = 0
var currentAnim = "idle"
var isWalking = false

var walkx = 0.0
var walky = 0.0
var startx = 0.0
var starty = 0.0
var repeatset = 120
var repeat = 0

func _ready() -> void:
	mouse.position.x = save.contents_to_save.mousex
	mouse.position.y = save.contents_to_save.mousey
	aliveTime = float(save.contents_to_save.timeAlive)
	eventTimer.start()

func returnToIdle():
	mouseSprite.stop()
	mouseSprite.play("idle")
	currentAnim = "idle"

func walkto(x,y):
	isWalking = true
	startx = mouse.position.x
	starty = mouse.position.y
	repeat = repeatset
	
	var diffX = x - mouse.position.x 
	var diffY = y - mouse.position.y

	if x < mouse.position.x:
		mouseSprite.flip_h = true
	else:
		mouseSprite.flip_h = false
	if repeat == 0:
		walkx = 0
		walky = 0

	walkx = diffX / repeat
	walky = diffY / repeat
	mouseSprite.play("walk")

func chooseEvent():
	var theChoice = randi_range(1,10)
	if theChoice <= 8: #80% for a random event
		consecutiveEvents += 1
		print("amonation")
		#if theChoice in [0,1,2,3]: #40% for walk
		if true:
			currentAnim = "walk"
			walkto(randi_range(65, 447),randi_range(310, 448))
		elif theChoice in [4,5,6,7]: #40% for itch
			currentAnim = "itch"
			mouseSprite.play("itch")
		else: #otherwise he just looks to the other side and looks back
			currentAnim = "look"
			mouseSprite.play("look")
		print("chose anim: "+currentAnim)

func _on_autosave_timeout() -> void:
	save.contents_to_save.mousex = mouse.position.x
	save.contents_to_save.mousey = mouse.position.y
	save.contents_to_save.timeAlive = int(aliveTime)

func _on_event_timeout() -> void:
	if not consecutiveEvents >= 2:
		eventTimer.wait_time = randi_range(5,10)
		chooseEvent()
		eventTimer.start()
	else:
		consecutiveEvents = 0
		currentAnim = "sleep"
		mouseSprite.play("sleep")

func _on_sprite_animation_finished() -> void:
	print("stop moving")
	returnToIdle()
	
func _input(_event):
	if currentAnim == "sleep":
		returnToIdle()
		eventTimer.start()

func _process(delta: float) -> void:
	aliveTime += delta
	
	if repeat == 0 and isWalking:
		isWalking = false
		returnToIdle()
	if isWalking:
		mouse.position.x += walkx
		mouse.position.y += walky
		print("|startx: "+str(startx)+"|starty: "+ str(starty)+"|walkx: "+str(walkx)+"|walky: "+str(walky))
		repeat -= 1
	
	mouse.position.x = clamp(mouse.position.x, 65, 447) #holy shit this is way better
	mouse.position.y = clamp(mouse.position.y, 310, 448)
	
