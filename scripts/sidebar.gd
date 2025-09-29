extends Sprite2D
@onready var all: Sprite2D = $"."
@onready var arrow: Sprite2D = $arrow
@onready var clickarea: Area2D = $arrow/clickarea
@onready var food_authority: Node2D = $"../../../foodAuthority"
@onready var panel: Sprite2D = %Panel
@onready var mouse: Node2D = $"../../../mouse"

var out = false

var start = -256
var end = 0

var start2 = 74.5
var end2 = 64.5

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if mouse.dead:
		out = false
	if out:
		if int(all.position.x) > end-3:
			all.position.x = end
		else:
			all.position.x += (end-all.position.x)*delta*2
			
		if clickarea.panelTouchDown:
			if int(arrow.position.y) < end2-3:
				arrow.position.y = end2
			else:
				arrow.position.y += (end2-arrow.position.y)*delta*2
	else:
		if int(all.position.x) < start+3:
			all.position.x = start
		else:
			all.position.x += (start-all.position.x)*delta*2
			
		if clickarea.panelTouchDown:
			if int(arrow.position.y) > start2+3:
				arrow.position.y = start2
			else:
				arrow.position.y += (start2-arrow.position.y)*delta*2
				
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right") and not panel.goDown:
		clickarea.panelTouchDown = true
		out = !out
	if panel.goDown:
		out = false

func _on_button_pressed() -> void: #feed button
	if out:
		food_authority.spawn()

func _on_button_2_pressed() -> void:
	if out:
		food_authority.spawn(true)
