extends Node

var autosaveTime = 30
var musicVolume = 75
var sfxVolume = 75

const save_location = "user://savefile.json"

func settingLoad():
	var file
	file = FileAccess.open_encrypted_with_pass(save_location, FileAccess.READ,"pipmousidontactuallyexpectthistobesafejustputtingthishereforfunsies")
	var data = file.get_var()
	file.close()
	if data.has("autosaveTime"):
		autosaveTime = data.autosaveTime
	else:
		autosaveTime = 30
		
	if data.has("musicvolume"):
		musicVolume = data.musicvolume
	else:
		musicVolume = 75
		
	if data.has("sfxvolume"):
		sfxVolume = data.sfxvolume
	else:
		sfxVolume = 75

func _ready() -> void:
	settingLoad()
