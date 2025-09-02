extends Node2D
@onready var art: Sprite2D = $art
@onready var room: Sprite2D = $room

var rng = RandomNumberGenerator.new()

var maxart = 3
var maxroom = 3

func _ready() -> void:
	var artt = load('res://assets/bg/art/art'+str(rng.randi_range(1,maxart))+'.png')
	var backgroundt = load('res://assets/bg/rooms/room'+str(rng.randi_range(1,maxroom))+'.png')
	art.texture = artt
	room.texture = backgroundt
