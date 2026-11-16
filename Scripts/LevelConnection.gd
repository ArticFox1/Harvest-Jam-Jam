extends Node2D

@export var NextLevel: StringName = "Level 1"

signal EndReached

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.name == &"PlayerCharacter":
		return
	EndReached.emit(NextLevel)
