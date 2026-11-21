extends Node2D

@export var Enabled: bool = true
@export_range(0,100,1,"prefer_slider","suffix:%") var TargetFocus: float = 25:
	set(v):
		TargetFocus = v
		FocusPercent = v * 0.0
var FocusPercent: float = .25
@onready var Collider: Area2D = $Area2D

func _ready() -> void:
	add_to_group(&"CameraTargets")
