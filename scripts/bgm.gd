extends AudioStreamPlayer2D
@export var playlist: Array[AudioStream] = []
@onready var player: AudioStreamPlayer2D = $"."

var song = 0

func _ready() -> void:
	play_song(song)
	song = (song+1)%len(playlist)

func play_song(index: int):
	if index >= 0 and index < playlist.size():
		player.stream = playlist[index]
		player.play()

func _on_finished() -> void:
	play_song(song)
	song = (song+1)%len(playlist)
