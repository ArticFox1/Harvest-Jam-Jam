extends Camera2D

@onready var Player = get_node("../Player/PlayerCharacter")
@onready var GameManager = get_node("..")

func ClampPosition(In: Vector2) -> Vector2:
	var Res: Vector2 = In
	match GameManager.LevelName:
		"Level 1":
			Res.x = maxf(Res.x,-16)
			if Res.x < 1500:
				Res.x = minf(Res.x,1376)
			Res.x = minf(Res.x,1472)
			
			if Res.x < 96:
				Res.y = maxf(Res.y,-80)
			if Res.x < 1472:
				
				Res.y = maxf(Res.y,-166)
			Res.y = maxf(Res.y,-230.0)
	return Res

func _process(dt: float) -> void:
	var Target: Vector2 = Player.global_position
	Target = ClampPosition(Target)
	
	global_position = lerp(global_position, Target, 1-exp(-8*dt))
	global_position = ClampPosition(global_position)
	
	print(global_position) 
