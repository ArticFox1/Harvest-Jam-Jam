extends Node2D

const DeadBody: PackedScene = preload("res://Harvest-Jam-Jam/Scenes/LevelEffects/DeadPlayer.tscn") as PackedScene
@onready var Player: Node2D = get_node("Player/PlayerCharacter") as Node2D
@onready var Camera: Camera2D = get_node("Camera2D")
@onready var LevelContainer: Node2D = get_node("Level")
@onready var BodyContainer: Node2D = get_node("DeadBodies")

var Levels := {
	&"Level1": preload("res://Harvest-Jam-Jam/Scenes/Levels/Level1.tscn") as PackedScene,
	&"Level2": preload("res://Harvest-Jam-Jam/Scenes/Levels/Level2.tscn") as PackedScene,
	&"Level3": preload("res://Harvest-Jam-Jam/Scenes/Levels/level3.tscn") as PackedScene,
	&"LevelEnd": preload("res://Harvest-Jam-Jam/Scenes/Levels/LevelEnd.tscn") as PackedScene,
}

var LevelName: StringName

func QueueFreeChildren(Parent: Node) -> void:
	for i in Parent.get_children():
		i.queue_free()

func ExitLevel(Next: StringName) -> void:
	SetupLevel(Next)

func DeathSignal() -> void:
	var New = DeadBody.instantiate()
	BodyContainer.call_deferred(&"add_child",New)
	New.global_position = Player.global_position
	await get_tree().create_timer(0).timeout
	Camera.global_position = Player.global_position



func SetupLevel(Name: StringName) -> void:
	if not Levels[Name]:
		print("Not a valid level name")
	for i in get_tree().get_nodes_in_group(&"LevelExits"):
		i.EndReached.disconnect(ExitLevel)
	LevelName = Name
	QueueFreeChildren(LevelContainer)
	QueueFreeChildren(BodyContainer)
	var NewLevel = Levels[Name].instantiate()
	await LevelContainer.call_deferred("add_child",NewLevel)
	await get_tree().create_timer(0).timeout
	if has_node("Level/"+LevelName+"/PlayerSpawn"):
		Player.global_position = get_node("Level/"+LevelName+"/PlayerSpawn").global_position
		Player.RespawnPoint = Player.global_position
		Camera.global_position = Player.global_position
	for i in get_tree().get_nodes_in_group(&"LevelExits"):
		i.EndReached.connect(ExitLevel)

func _ready() -> void:
	Player.Died.connect(DeathSignal)
	SetupLevel(&"Level3")
