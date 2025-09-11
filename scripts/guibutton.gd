extends Area2D
@onready var panel: Sprite2D = $"../.."

func _input_event(_viewport, event, _someint):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if not panel.goDown:
			self.on_click()

func on_click():
	panel.goDown = true
