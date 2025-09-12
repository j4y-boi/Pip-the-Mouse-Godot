extends Sprite2D

func _process(delta: float) -> void:
	if $"../..".visible:
		$".".rotation += delta*2
	else:
		$'.'.rotation = 0
