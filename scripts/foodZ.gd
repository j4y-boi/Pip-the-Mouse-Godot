extends Sprite2D

@onready var shadow: Sprite2D = Sprite2D.new()

func _ready() -> void:
	await get_tree().process_frame
	shadow.texture = texture
	shadow.position = Vector2(2, -4)
	shadow.modulate = Color(0, 0, 0, 0.4)
	shadow.z_index = -1
	shadow.set_script(null) #les hope for the best frfr🙏🙏
	add_child(shadow)
	
func _process(_delta) -> void:
	@warning_ignore("narrowing_conversion")
	var e = 0.005 * float(position.y) + 1
	scale = Vector2(e,e)
	z_index = position.y - 1
