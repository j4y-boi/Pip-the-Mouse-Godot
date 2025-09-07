extends VBoxContainer

@export var playScene : PackedScene
@onready var fg: ColorRect = $"../fg"
@onready var settingsMenu: Panel = $"../Settings"
@onready var defaultButtons: VBoxContainer = $"."

func _ready() -> void:
	fg.modulate.a = 0.0
	fg.visible = false

func _on_quit_pressed() -> void:
	fg.visible = true
	$"../back".play()
	var tween = self.create_tween()
	tween.tween_property(fg, "modulate:a", 1.0, 0.5)
	tween.tween_interval(.5)
	await tween.finished
	get_tree().quit()

func _on_settings_pressed() -> void:
	defaultButtons.visible = false
	settingsMenu.visible = true

func _on_start_pressed() -> void:
	fg.visible = true
	$"../confirm".play()
	var tween = self.create_tween()
	tween.tween_property(fg, "modulate:a", 1.0, 1)
	tween.tween_interval(.5)
	await tween.finished
	get_tree().change_scene_to_packed(playScene)

func _on_back_pressed() -> void:
	defaultButtons.visible = true
	settingsMenu.visible = false
