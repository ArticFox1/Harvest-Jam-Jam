extends Node2D

const DeadBody: PackedScene = preload("res://Haven-Jam-Jam/Scenes/Dead Player.tscn")
@onready var Player = get_node("Player/PlayerCharacter") as Node2D
@onready var Camera = get_node("Camera2D")

func DeathSignal() -> void:
	var New = DeadBody.instantiate()
	add_child(New)
	New.global_position = Player.global_position
	await get_tree().create_timer(0).timeout
	Camera.global_position = Player.global_position

func _ready() -> void:
	Player.Died.connect(DeathSignal)
	if get_node("Level/Player Spawn"):
		Player.global_position = get_node("Level/Player Spawn").global_position
		Player.RespawnPoint = Player.global_position
		Camera.global_position = Player.global_position
