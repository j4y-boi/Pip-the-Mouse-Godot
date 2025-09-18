extends Control
@onready var save_timer: Timer = $"../../Save/Autosave"
@onready var wait_until_save: Timer = $"../../Save/WaitUntilSave"
@onready var fade: ColorRect = $"../../fadeout/Control2/ColorRect"
@onready var menu: Control = $"."

var is_exiting = false
var inmenu = false
var end = -512
var start = 0

func actual_save():
	save_timer.stop()
	save_timer.emit_signal("timeout")
	await wait_until_save.timeout
	
func return_to_main():
	fade.visible = true
	var tween = self.create_tween()
	tween.tween_property(fade, "modulate:a", 1.0, 1)
	tween.tween_interval(.5)
	await tween.finished
	await get_tree().process_frame
	
	var mainmenu = load("res://scenes/menu.tscn") as PackedScene
	get_tree().change_scene_to_packed(mainmenu)

func _ready() -> void:
	menu.position.x = end

func _process(delta: float) -> void:
	if inmenu:
		if int(menu.position.x) > start-3:
			menu.position.x = start
		else:
			menu.position.x += (start-menu.position.x)*delta*5
	else:
		if int(menu.position.x) < end+3:
			menu.position.x = end
		else:
			menu.position.x += (end-menu.position.x)*delta*5

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		inmenu = !inmenu

func _on_quit_pressed() -> void:
	if not is_exiting:
		is_exiting = true
		await actual_save()
		await return_to_main()

func _on_close_pressed() -> void:
	inmenu = false

func _on_save_pressed() -> void:
	await actual_save()

func _on_button_pressed() -> void:
	inmenu = true
