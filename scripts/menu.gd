extends Control

@export var playScene: PackedScene = preload("res://scenes/game.tscn") #FUCK you godot im gonna load it this way and youre gonna be alright with it
@onready var fg: ColorRect = $fg
@onready var settingsMenu: Panel = $Settings
@onready var defaultButtons: VBoxContainer = $button
@onready var logo: Sprite2D = $Itchiobanner
@onready var settingVars: Node = $settingsVar
@onready var stats: Panel = $stats

var start = -95
var end = 100
var time = 0.0
const save_location = "user://savefile.json"

var music_bus = AudioServer.get_bus_index("Music")
var sfx_bus = AudioServer.get_bus_index("SFX")

const killedMsg = {
	5: "Woah, good job!",
	7: "Stiil decent!",
	14: "Mkay...",
	20: "...You're supposed to keep Pip alive?",
	50: "Huh. UHhh? UHHHhh",
	100: "Okay. What is this?",
	400: "Buh. HOW??",
	600: "YOU SPENT MORE TIME LETTING HIM DIE THAN PLAYING THE GAME??"
}

func statsSetup():
	const judgement = "user://judgement"
	if FileAccess.file_exists(judgement):
		var file = FileAccess.open_encrypted_with_pass(judgement, FileAccess.READ,"pipmousidontactuallyexpectthistobesafejustputtingthishereforfunsies")
		var data = file.get_var()
		file.close()
		var source = data["longestAlive"]
		var hours   = int(source / 3600) % 24
		var minutes = int(source / 60) % 60
		var seconds = int(source) % 60
		var format_string = "%s:%s:%s"
		
		$stats/contents/aliveTime.text = format_string%["%02d" % hours, "%02d" % minutes,"%02d" % seconds]
		$stats/contents/killed.text = str(data["miceKilled"])
		
		var killed = data["miceKilled"]
		for threshold in killedMsg.keys():
			if killed <= threshold:
				$stats/splashText.text = killedMsg[threshold]
				return
		$stats/splashText.text = killedMsg[killedMsg.keys().max()]
		
func settingSetup():
	await settingVars.settingLoad()
	$Settings/contents/music/musicVolume.value = settingVars.musicVolume
	$Settings/contents/sfx/sfxVolume.value = settingVars.sfxVolume
	$Settings/contents/autosave/autosaveInterval.value = settingVars.autosaveTime
	
func percentVolumeTodB(percent: float) -> float:
	if percent <= 0.0:
		return -80.0  # idk  this is how low the audio mixer goes so ig that its silent
	return 50.0 * log(percent / 100.0) / log(10) #nahhh cuz why humans dont hear linearly frfr

func _ready() -> void:
	fg.modulate.a = 0.0
	fg.visible = false
	logo.position.y = start
	settingSetup()
	statsSetup()
	
func _process(delta: float) -> void:
	if settingsMenu.visible:
		$Settings/contents/autosave/label.text = str(int($Settings/contents/autosave/autosaveInterval.value))+'s'
		$Settings/contents/music/label.text = str(int($Settings/contents/music/musicVolume.value))+'%'
		$Settings/contents/sfx/label.text = str(int($Settings/contents/sfx/sfxVolume.value))+'%'
		
		settingVars.musicVolume = $Settings/contents/music/musicVolume.value
		settingVars.sfxVolume = $Settings/contents/sfx/sfxVolume.value
		settingVars.autosaveTime = $Settings/contents/autosave/autosaveInterval.value
		
	AudioServer.set_bus_volume_db(music_bus, percentVolumeTodB(settingVars.musicVolume))
	AudioServer.set_bus_volume_db(sfx_bus, percentVolumeTodB(settingVars.sfxVolume))

	time += delta
	logo.rotation = (sin(time))/10
	if int(logo.position.y) > end-3:
		logo.position.y = end
	else:
		logo.position.y += (end-logo.position.y)*delta*2

func _on_quit_pressed() -> void:
	fg.visible = true
	$back.play()
	var tween = self.create_tween()
	tween.tween_property(fg, "modulate:a", 1.0, 0.5)
	tween.tween_interval(.5)
	await tween.finished
	get_tree().quit()

func _on_settings_pressed() -> void:
	defaultButtons.visible = false
	settingsMenu.visible = true
	settingSetup()

func _on_start_pressed() -> void:
	fg.visible = true
	$confirm.play()
	var tween = self.create_tween()
	tween.tween_property(fg, "modulate:a", 1.0, 1)
	tween.tween_interval(.5)
	await tween.finished
	await get_tree().process_frame
	get_tree().change_scene_to_packed(playScene)

func _on_back_pressed() -> void:
	defaultButtons.visible = true
	settingsMenu.visible = false
	stats.visible = false
	settingVars.settingSave()

func _on_link_pressed() -> void:
	OS.shell_open("https://j4y-boi.itch.io/")

func _on_stats_pressed() -> void:
	defaultButtons.visible = false
	stats.visible = true
	statsSetup()
