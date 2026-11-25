extends Node2D

@export_node_path() var SubjectPath: NodePath:
	set(v):
		SubjectPath = v
		if has_node(SubjectPath):
			Subject = get_node(SubjectPath)
var Subject: Node
@export var Property: StringName = &""
@export var NewValue: Variant

func _ready() -> void:
	add_to_group(&"AreaFlag")
	Subject = get_node(SubjectPath)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.name == &"PlayerCharacter":
		return
	Subject.set(Property,NewValue)
