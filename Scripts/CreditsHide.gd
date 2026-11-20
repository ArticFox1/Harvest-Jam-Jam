extends TextureRect

func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	var Fade = get_tree().create_tween()
	Fade.tween_property(self,"modulate",Color("00000000"),0.5)
	Fade.play()
	await Fade.finished
