extends Area2D
@onready var panel: Sprite2D = %Panel
@onready var sidebar: Sprite2D = %sidebar
@export var isPanel:bool

var touchDown = false
var panelTouchDown = false

func _input_event(_viewport, event, _someint):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		self.on_click()

func on_click():
	if isPanel:
		if not(panel.goDown and touchDown):
			panel.goDown = not panel.goDown
			
			if panel.goDown:
				sidebar.out = false
				
			if panel.goDown:
				touchDown = false
			else:
				touchDown = true
	else:
		if not(sidebar.out and panelTouchDown):
			sidebar.out = !sidebar.out
			
			if sidebar.out:
				panel.goDown = false
				
			if sidebar.out:
				panelTouchDown = false
			else:
				panelTouchDown = true
