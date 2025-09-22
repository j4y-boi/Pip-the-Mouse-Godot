extends Node
@export var soundtrack: Array[AudioStream] = []
@onready var player: AudioStreamPlayer2D = $"../bgm"
@onready var inside_light: CanvasModulate = $"../insideLight"
@onready var outside_light: CanvasModulate = $"../ParallaxBackground/outsideLight"

var song = 0
var gametime = 0.0
var intgametime = 0
var daynightcycle = 10

var isNight = false
var intransition = false

func _ready() -> void:
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
		tween.tween_property(outside_light, "color",Color(0.25, 0.25, 0.25, 1), 1)
		tween.tween_property(inside_light, "color",Color(0.5, 0.5, 0.5, 1), 1)
	else:
		tween.tween_property(outside_light, "color",Color(1, 1, 1, 1), 1)
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
