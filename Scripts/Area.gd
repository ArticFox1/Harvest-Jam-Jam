@tool
class_name Area
extends Node2D

@export var Enabled: bool = true
@export var Offset: Vector2 = Vector2.ZERO:
	set(v):
		Offset = v
		queue_redraw()
@export var HalfSize: Vector2 = Vector2.ONE * 4:
	set(v):
		HalfSize = v.maxf(0)
		queue_redraw()
@export_subgroup("Debug")
@export var DebugEnabled: bool = true:
	set(v):
		DebugEnabled = v
		queue_redraw()
@export var EditorOnly: bool = true
@export var FillColor: Color = Color("0000ff40"):
	set(v):
		FillColor = v
		queue_redraw()
@export var OutlineColor: Color = Color("0000ffff"):
	set(v):
		OutlineColor = v
		queue_redraw()
@export var OutlineSize: float = 1:
	set(v):
		OutlineSize = clampf(v,0,minf(HalfSize.x,HalfSize.y))
		queue_redraw()

var GlobalPosition: Vector2:
	get():
		return global_position + Offset

func _draw() -> void:
	if not DebugEnabled:
		return
	draw_rect(Rect2(Offset-HalfSize,HalfSize*2),FillColor)
	draw_rect(Rect2(Offset-HalfSize+Vector2.ONE*0.5*OutlineSize,HalfSize*2-Vector2.ONE*OutlineSize),OutlineColor,false,OutlineSize)

func _ready() -> void:
	if EditorOnly:
		DebugEnabled = false
