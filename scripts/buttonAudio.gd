extends VBoxContainer
#ts is hella inefficient, but i dont have a better solution
@onready var hover: AudioStreamPlayer2D = $"../hover"
func hoverPlay():
	hover.play()

func _on_start_mouse_entered() -> void:
	hoverPlay()

func _on_settings_mouse_entered() -> void:
	hoverPlay()

func _on_quit_mouse_entered() -> void:
	hoverPlay()

func _on_back_mouse_entered() -> void:
	hoverPlay()

func _on_stats_mouse_entered() -> void:
	hoverPlay()
