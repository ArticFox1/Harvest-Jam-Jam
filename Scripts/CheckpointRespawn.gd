extends AnimatedSprite2D

@export var RespawnOffset: Vector2 = Vector2.ZERO

signal Checkpoint

func _ready() -> void:
	add_to_group(&"Checkpoints")
	play(&"Unbroken")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != &"PlayerCharacter" or animation != &"Unbroken":
		return
	Checkpoint.emit(self,global_position+RespawnOffset)
	play(&"Braking")
	await animation_finished
	play(&"Broken")
