extends Node
@export var soundtrack: Array[AudioStream] = []
@onready var player: AudioStreamPlayer2D = $"../bgm"
@onready var inside_light: CanvasModulate = $"../insideLight"
@onready var sky: Sprite2D = $"../bg/ParallaxBackground/ParallaxLayer/sky"
@onready var clouds: Sprite2D = $"../bg/ParallaxBackground/ParallaxLayer/Sprite2D"

var song = 0
var gametime = 0.0
var intgametime = 0
var daynightcycle = 10

var isNight = true
var intransition = false

func _ready() -> void:
	randomize()
	soundtrack.shuffle()
	play_song(song)
	song = (song+1)%len(soundtrack)

#bgm related
func play_song(index: int):
	if index >= 0 and index < soundtrack.size():
		player.stream = soundtrack[index]
		player.play()

func _on_bgm_finished() -> void:
	play_song(song)
	song = (song+1)%len(soundtrack)
# -

func nightMode(night):
	var tween = self.create_tween()
	if night:
		tween.tween_property(sky, "modulate",Color(0.183, 0.056, 0.202, 1), 1)
		tween.tween_property(clouds, "modulate",Color(0.37, 0.37, 0.37, 1), 1)
		tween.tween_property(inside_light, "color",Color(0.5, 0.5, 0.5, 1), 1)
	else:
		tween.tween_property(sky, "modulate",Color(1, 1, 1, 1), 1)
		tween.tween_property(clouds, "modulate",Color(1, 1, 1, 1), 1)
		tween.tween_property(inside_light, "color",Color(1, 1, 1, 1), 1)
	await tween.finished
	intransition = false

func _process(delta: float) -> void:
	gametime += delta
	intgametime = int(floor(gametime))
	if intgametime%daynightcycle == 0 and not intransition:
		intransition = true
		isNight = !isNight
		nightMode(isNight)
