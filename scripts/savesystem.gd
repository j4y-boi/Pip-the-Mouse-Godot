extends Node

@onready var room: Sprite2D = $"../bg/room"
@onready var art: Sprite2D = $"../bg/art"
@onready var mouse: Node2D = $"../mouse"
@onready var autosave: Timer = $Autosave
@onready var wait_until_save: Timer = $WaitUntilSave
@onready var icon: Node2D = $"../fadeout/icon"

const save_location = "user://savefile.json"
const permanentRecord = "user://judgement"
var contents_to_save: Dictionary = {
	"version" = 5,
	"roomnum" = 1,
	"artnum" = 1,
	"mousex" = randi_range(65, 447),
	"mousey" = randi_range(310, 430),
	"timeAlive" = 0,
	"autosaveTime" = 30,
	"feedtimeleft" = 30,
	"dead" = false,
	"leftbehind" = false,
	"musicvolume" = 75,
	"sfxvolume" = 75,
}

var judgement: Dictionary = {
	"miceKilled" = 0,
	"longestAlive" = 0,
}

var success = true

var rng = RandomNumberGenerator.new()
var maxart = 3
var maxroom = 3

func saveData():
	var file
	var file2
	contents_to_save.version = len(contents_to_save)-1
	file = FileAccess.open_encrypted_with_pass(save_location, FileAccess.WRITE, "pipmousidontactuallyexpectthistobesafejustputtingthishereforfunsies")
	file2 = FileAccess.open_encrypted_with_pass(permanentRecord, FileAccess.WRITE, "pipmousidontactuallyexpectthistobesafejustputtingthishereforfunsies")
	file.store_var(contents_to_save.duplicate())
	file.close()
	
	file2.store_var(judgement.duplicate())
	file2.close()

func loadData():
	success = false
	if FileAccess.file_exists(save_location):
		var file
		var file2
		file = FileAccess.open_encrypted_with_pass(save_location, FileAccess.READ,"pipmousidontactuallyexpectthistobesafejustputtingthishereforfunsies")
		file2 = FileAccess.open_encrypted_with_pass(permanentRecord, FileAccess.READ,"pipmousidontactuallyexpectthistobesafejustputtingthishereforfunsies")
		var data = file.get_var()
		file.close()
		
		var data2 = file2.get_var()
		file2.close()
		
		for key in contents_to_save.keys(): #added a bit more security in case a scriptkiddy tries to change their timealive to "hackd"
			if data.has(key) and typeof(data[key]) == typeof(contents_to_save[key]):
				contents_to_save[key] = data[key]
				
		for key in judgement.keys():
			if data2.has(key) and typeof(data2[key]) == typeof(judgement[key]):
				judgement[key] = data2[key]
			
		contents_to_save.roomnum = clamp(contents_to_save.roomnum, 1, maxroom)
		contents_to_save.artnum = clamp(contents_to_save.artnum, 1, maxart)
		
		success = true
		
		if typeof(data) != TYPE_DICTIONARY:
			data = contents_to_save.duplicate()
			success = false
		if typeof(data2) != TYPE_DICTIONARY:
			data2 = judgement.duplicate()
			success = false
	else:
		success = false

func _ready() -> void:
	contents_to_save.version = len(contents_to_save)-1
	loadData()
	if not success:		
		var ranart = rng.randi_range(1,maxart)
		var ranbg = rng.randi_range(1,maxroom)
		
		var artt = load('res://assets/bg/art/art'+str(ranart)+'.png')
		var backgroundt = load('res://assets/bg/rooms/room'+str(ranbg)+'.png')

		art.texture = artt
		room.texture = backgroundt
		
		contents_to_save.roomnum = ranbg
		contents_to_save.artnum = ranart
		
		saveData()
		print("generated save file")
	else:
		print("loaded a found save file running version "+str(contents_to_save.version))
		
		var artt = load('res://assets/bg/art/art'+str(contents_to_save.artnum)+'.png')
		var backgroundt = load('res://assets/bg/rooms/room'+str(contents_to_save.roomnum)+'.png')

		art.texture = artt
		room.texture = backgroundt
		print("loaded room art: "+str(contents_to_save.artnum)+" | room: "+str(contents_to_save.roomnum))
		
		#mouse.position.x = contents_to_save.mousex
		#mouse.position.y = contents_to_save.mousey
		print("loaded mouse coords at ("+str(contents_to_save.mousex)+","+str(contents_to_save.mousey)+")")
		
		autosave.stop()
		autosave.wait_time = contents_to_save.autosaveTime
		autosave.start()
		print("set autosave pref to: "+str(contents_to_save.autosaveTime))
		
		saveData()
		

func _on_wait_until_save_timeout() -> void:
	saveData()
	print("Saved")
	icon.visible = false

func _on_autosave_timeout() -> void:
	print("Waiting...")
	wait_until_save.start()
	icon.visible = true
