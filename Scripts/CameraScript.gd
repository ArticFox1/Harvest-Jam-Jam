extends Camera2D

@onready var Player = get_node("../Player/PlayerCharacter")
@onready var GameManager = get_node("..")

const CameraResolution: Vector2 = Vector2(320,180)

func ClampPosition(In: Vector2) -> Vector2:
	var Res: Vector2 = In
	for i in get_tree().get_nodes_in_group("CameraBorders"):
		if not i.Enabled:
			continue
		var MoveTo: Vector2 = (Res - i.GlobalPosition)
		var Diff: Vector2 = MoveTo.abs() - (i.HalfSize + 0.5 * CameraResolution)
		var Dist: float = minf(maxf(Diff.x,Diff.y),0)
		if Dist < 0:
			if Diff.x > Diff.y:
				Res.x += absf(Dist) * signf(MoveTo.x)
			else:
				Res.y += absf(Dist) * signf(MoveTo.y)
	return Res

func FocusTargets(In: Vector2) -> Vector2:
	var Res: Vector2 = In
	var ForRes: Array[Vector2] = []
	for i in get_tree().get_nodes_in_group("CameraTargets"):
		if not i.Enabled or i.TargetFocus == 0:
			continue
		ForRes.append(Res.lerp(i.global_position,i.TargetFocus))
	Res = ForRes.reduce(func Sum(accum): return accum)
	if ForRes.is_empty():
		return In
	Res /= ForRes.size()
	return Res

func _process(dt: float) -> void:
	var Target: Vector2 = Player.global_position
	#Target = FocusTargets(Target)
	Target = ClampPosition(Target)
	
	global_position = lerp(global_position, Target, 1-exp(-8*dt))
	#global_position = ClampPosition(global_position)
