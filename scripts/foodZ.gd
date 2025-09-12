extends Sprite2D

#@onready var shadow: Sprite2D = Sprite2D.new()

#func _ready() -> void: # i present: goofy ahh shadow solution
	#shadow.texture = $".".texture
	#shadow.skew = 30
	#shadow.position = Vector2(2, 0)
	#shadow.modulate = Color(0,0,0,0.4)
	#shadow.z_index = -1
	#shadow.z_as_relative = false
	#add_child(shadow)

func _process(_delta) -> void:
	@warning_ignore("narrowing_conversion")
	z_index = position.y - 1
