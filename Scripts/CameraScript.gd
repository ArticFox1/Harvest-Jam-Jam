extends Camera2D

@onready var Follow: Node2D = $"../Player"

const FollowSpeed: float = 9

func _process(dt: float) -> void:
	global_position = position.lerp(Follow.global_position,1-exp(-FollowSpeed*dt))
