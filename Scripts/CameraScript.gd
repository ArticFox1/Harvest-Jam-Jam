extends Camera2D

@onready var Player = get_node("../Player/PlayerCharacter")

func _process(dt: float) -> void:
	var Target: Vector2 = Player.global_position
	Target.x = maxf(Target.x,-16)
	Target.x = minf(Target.x,1376)
	if Target.x < 96:
		Target.y = maxf(Target.y,-80)
	Target.y = maxf(Target.y,-166)
	global_position = lerp(global_position, Target, 1-exp(-9*dt))
	
	print(global_position) 
