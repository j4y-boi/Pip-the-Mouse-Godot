extends Control

@export var load_scene : PackedScene
@export var in_time : float = 0.5
@export var fade_in_time : float = 1.5
@export var pause_time : float = 1.5
@export var fade_out_time : float = 1.5
@export var out_time : float = 0.5
@export var splash_screen_container : Node
@export var fg : ColorRect

var splash_screens : Array
var uhh = true

func get_screens():
	splash_screens = splash_screen_container.get_children()
	for screen in splash_screens:
		screen.modulate.a = 0.0
	fg.modulate.a = 0.0
	fg.visible = true

func fade():
	for screen in splash_screens:
		var tween = self.create_tween()
		tween.tween_interval(in_time)
		tween.tween_property(screen, "modulate:a", 1.0, fade_in_time)
		tween.tween_interval(pause_time)
		tween.tween_property(screen, "modulate:a", 0.0, fade_out_time)
		tween.tween_interval(out_time)
		await tween.finished
	get_tree().change_scene_to_packed(load_scene)
	
func _unhandled_input(event: InputEvent):
	if event.is_pressed() and uhh:
		uhh = false
		var tween = self.create_tween()
		tween.tween_property(fg, "modulate:a", 1.0, 0.25)
		tween.tween_interval(out_time)
		await tween.finished
		get_tree().change_scene_to_packed(load_scene)
	
func _ready():
	get_screens()
	fade()
