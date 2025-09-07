extends Node

@onready var room: Sprite2D = $"../bg/room"
@onready var art: Sprite2D = $"../bg/art"
@onready var mouse: Node2D = $"../mouse"
@onready var autosave: Timer = $Autosave
@onready var wait_until_save: Timer = $WaitUntilSave

const encrypt = false

const save_location = "user://savefile.json"
var contents_to_save: Dictionary = {
	"version" = 5,
	"roomnum" = 1,
	"artnum" = 1,
	"mousex" = 91.0,
	"mousey" = 297.0,
	"timeAlive" = 0,
	"autosaveTime" = 30,
	"feedtimeleft" = 30,
	"dead" = false,
}

var success = true

var rng = RandomNumberGenerator.new()
var maxart = 3
var maxroom = 3

func saveData():
	var file
	contents_to_save.version = len(contents_to_save)-1
	if encrypt:
		file = FileAccess.open_encrypted_with_pass(save_location, FileAccess.WRITE, "pipmousidontactuallyexpectthistobesafejustputtingthishereforfunsies")
	else:
		file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(contents_to_save.duplicate())
	file.close()

func loadData():
	if FileAccess.file_exists(save_location):
		var file
		if encrypt:
			file = FileAccess.open_encrypted_with_pass(save_location, FileAccess.READ,"pipmousidontactuallyexpectthistobesafejustputtingthishereforfunsies")
		else:
			file = FileAccess.open(save_location, FileAccess.READ)
		var data = file.get_var()
		file.close()
		
		for key in contents_to_save.keys():
			if data.has(key):
				contents_to_save[key] = data[key]
			
		success = true
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
		print("generated room+saved")
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
		
		print(contents_to_save)
		
		saveData()
		

func _on_wait_until_save_timeout() -> void:
	saveData()
	print("saved")

func _on_autosave_timeout() -> void:
	print("waiting til everything is set")
	wait_until_save.start()
