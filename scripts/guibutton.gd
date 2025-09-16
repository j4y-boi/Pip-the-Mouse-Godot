extends Area2D
@onready var panel: Sprite2D = $"../.."

var touchDown = false

func _input_event(_viewport, event, _someint):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		self.on_click()

func on_click():
	if not(panel.goDown and touchDown):
		panel.goDown = not panel.goDown
		if panel.goDown:
			touchDown = false
		else:
			touchDown = true
