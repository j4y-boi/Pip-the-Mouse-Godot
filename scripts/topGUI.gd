extends Sprite2D
@onready var all: Sprite2D = $"."
@onready var mouse: Node2D = $"../../mouse"
@onready var icon: Sprite2D = $icon
@onready var time: Label = $Label
@onready var arrow: Sprite2D = $arrow
@onready var food_authority: Node2D = $"../../foodAuthority"
@onready var save: Node = %Save
@onready var save_timer: Timer = $"../../Save/Autosave"
@onready var wait_until_save: Timer = $"../../Save/WaitUntilSave"
@onready var fade: ColorRect = $"../../fadeout/Control2/ColorRect"

#main gui bg vars
var goDown = false
var start = -256
var end = -132

var slidelimit = 2

var foodTextures:Array
var textured = load("res://assets/gui/heart.png")

var topguislide = 0

var start2 = 74.5
var end2 = 64.5
# -

var gametime = 0.0
var lasttime = 0
var options = []
var canreturn = false
var intgametime = 0
var talkstage = 0
var wasHunger = false
var doesreturn = false
var is_exiting := false

func actual_save():
	save_timer.stop()
	save_timer.emit_signal("timeout")
	await wait_until_save.timeout
	
func return_to_main():
	fade.visible = true
	var tween = self.create_tween()
	tween.tween_property(fade, "modulate:a", 1.0, 1)
	tween.tween_interval(.5)
	await tween.finished
	await get_tree().process_frame
	
	var mainmenu = load("res://scenes/menu.tscn") as PackedScene
	get_tree().change_scene_to_packed(mainmenu)

func random_sentence(lines: Array) -> void:
	time.text = lines[randi_range(0, lines.size() - 1)]
	
func _ready() -> void:
	foodTextures = food_authority.foodTextures
	doesreturn = save.contents_to_save.leftbehind
	fade.visible = false
	fade.color = Color.BLACK
	fade.modulate.a = 0.0
	for child in $"../../fadeout".get_children(): # im sorry, i generated these three line with ai
		if child is Control:
			child.mouse_filter = Control.MOUSE_FILTER_IGNORE


	
func _process(delta: float) -> void:
	gametime += delta
	intgametime = floor(gametime)
	
	if mouse.dead:
		topguislide = -1
	elif mouse.feedTimeLeft <= 0:
		topguislide = -2
	elif mouse.feedTimeLeft >= 900:
		topguislide = -3
		wasHunger = true
	elif mouse.feedTimeLeft < 900 and wasHunger:
		wasHunger = false
		topguislide = 999
		goDown = false
		
	if goDown or mouse.dead:
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
	if topguislide in [0,-1]:
		source = mouse.aliveTime
	elif topguislide in [1]:
		source = mouse.feedTimeLeft
	else:
		source = 0	
	var hours   = int(source / 3600) % 24
	var minutes = int(source / 60) % 60
	var seconds = int(source) % 60
	#---
	if topguislide == -1:
		icon.visible = false
		goDown = true
		if lasttime == 0:
			lasttime = intgametime
		
		if lasttime == 0  and talkstage == 0:
			talkstage += 1
			save.contents_to_save.leftbehind = true
			save.saveData()
			if doesreturn:
				random_sentence(["Uhh...","...","Hm..."])
			elif mouse.feedTimeLeft <= 0 or mouse.feedTimeLeft >= 600:
				random_sentence(["P-Pip? You there?","Is he okay?","Is he... Dead?"])
			else:
				random_sentence(["Huh...", "That's weird.", "Wait what?"])
		if intgametime == lasttime+5 and talkstage == 1:
			talkstage+=1
			if doesreturn:
				random_sentence(["Why'd you reload?","Did you reload the game?","Restarted the game, huh?"])
			elif mouse.feedTimeLeft <= 0:
				random_sentence(["He starved...","He ate too little...","Did you give him food?"])
			elif mouse.feedTimeLeft >= 600:
				random_sentence(["That's too much food...","You fed him too much...","A bit too much food..."])
			else:
				random_sentence(["This death wasn't..."])
		if intgametime == lasttime+10 and talkstage == 2:
			talkstage+=1
			if doesreturn:
				random_sentence(["He's still dead.","That didn't help.","Didn't change anything."])
			elif mouse.feedTimeLeft <= 0:
				random_sentence(["He needs to eat.","Mice eat too. Feed him.","Press [LEFT] to feed"])
			elif mouse.feedTimeLeft >= 600:
				random_sentence(["Mice eat less.","Don't give too much food.","Feed him less."])
			else:
				random_sentence(["Recognized?"])
		if intgametime == lasttime+15 and talkstage == 3:
			talkstage+=1
			time.text = "He was alive for: %s:%s:%s"%["%02d" % hours, "%02d" % minutes,"%02d" % seconds]
		if intgametime == lasttime+20 and talkstage == 4:
			talkstage+=1
			random_sentence(["Press [UP] to restart."])
			canreturn = true
	elif topguislide == -2:
		icon.visible = false
		goDown = true
		time.text = "Feed Pip! He's hungry!"
	elif topguislide == -3:
		icon.visible = false
		goDown = true
		time.text = "Slow down with the food..."
	elif topguislide == 0:
		var format_string = "Time alive: %s:%s:%s"
		time.text = format_string%["%02d" % hours, "%02d" % minutes,"%02d" % seconds]
		var beat = 0.5 + (int(mouse.aliveTime*1.5)%2)*0.1
		icon.texture = textured
		icon.rotation = 0
		icon.scale = Vector2(beat,beat)
	elif topguislide == 1:
		var format_string = "Hungry in: %s:%s"
		time.text = format_string%["%02d" % minutes,"%02d" % seconds]
		var beat = -0.5+(int(mouse.aliveTime)%2)*1
		icon.scale = Vector2(0.8,0.8)
		icon.texture = textured
		icon.rotation = beat
	#if topguislide == 2: #adding later
		#var format_string = "Time alive: %s:%s"
		#time.text = format_string%["%02d" % minutes,"%02d" % seconds]
		#var beat = 0.5 + (int(mouse.aliveTime*1.5)%2)*0.1
		#icon.scale = Vector2(beat,beat)

func _input(event):
	var ableToChange = goDown and not mouse.dead and not topguislide < 0
	
	if event.is_action_pressed("down") and not mouse.dead and not topguislide < 0:
		if topguislide == 999:
			icon.visible = true
			topguislide = 0
			textured = load("res://assets/gui/heart.png")
		goDown = !goDown
	
	if event.is_action_pressed("escape") and not is_exiting:
		is_exiting = true
		await actual_save()
		await return_to_main()
	
	if event.is_action_pressed("up") and canreturn: #IMPORTANT, OTHERWISE THEY MIGHT DELETE THEIR OWN SAVE
		print("nuked")
		#restore save, handled by savesystem at restart
		save.judgement.miceKilled += 1
		if mouse.aliveTime > save.judgement.longestAlive:
			save.judgement.longestAlive = mouse.aliveTime
			actual_save()
		
		var save_path = "user://savefile.json"
		if FileAccess.file_exists(save_path):
			DirAccess.remove_absolute(save_path)
		#reloads gam
		var thegame = get_tree().current_scene.scene_file_path
		get_tree().change_scene_to_file(thegame)
	
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
		
