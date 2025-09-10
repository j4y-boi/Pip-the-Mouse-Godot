extends Sprite2D

func _process(delta: float) -> void:
	$".".z_index = $".".position.y-3
