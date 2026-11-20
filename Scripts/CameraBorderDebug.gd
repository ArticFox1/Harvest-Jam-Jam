@tool
extends "res://Harvest-Jam-Jam/Scripts/Area.gd"

func _ready() -> void:
	add_to_group(&"CameraBorders")
	if EditorOnly:
		DebugEnabled = false
