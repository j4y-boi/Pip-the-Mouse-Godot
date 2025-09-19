extends Node

var autosaveTime:int
var musicVolume:int
var sfxVolume:int

const save_location = "user://savefile.json"
var data

func settingLoad():
	var file
	file = FileAccess.open_encrypted_with_pass(save_location, FileAccess.READ,"pipmousidontactuallyexpectthistobesafejustputtingthishereforfunsies")
	data = file.get_var()
	file.close()
	if data.has("autosaveTime"):
		autosaveTime = data.autosaveTime
	else:
		autosaveTime = 30
		data["autosaveTime"] = autosaveTime
		
	if data.has("musicvolume"):
		musicVolume = data.musicvolume
	else:
		musicVolume = 75
		data["musicvolume"] = musicVolume
		
	if data.has("sfxvolume"):
		sfxVolume = data.sfxvolume
	else:
		sfxVolume = 75
		data["sfxvolume"] = sfxVolume

func settingSave():
	var file
	
	sfxVolume = $"../Settings/contents/sfx/sfxVolume".value
	musicVolume = $"../Settings/contents/music/musicVolume".value
	autosaveTime = $"../Settings/contents/autosave/autosaveInterval".value
	
	data["sfxvolume"] = sfxVolume
	data["musicvolume"] = musicVolume
	data["autosaveTime"] = autosaveTime
	
	data.version = len(data)-1
	file = FileAccess.open_encrypted_with_pass(save_location, FileAccess.WRITE, "pipmousidontactuallyexpectthistobesafejustputtingthishereforfunsies")
	file.store_var(data.duplicate())
	file.close()

func _ready() -> void:
	settingLoad()
