extends Node2D

const DeadBody: PackedScene = preload("res://Haven-Jam-Jam/Scenes/Dead Player.tscn") as PackedScene
@onready var Player: Node2D = get_node("Player/PlayerCharacter") as Node2D
@onready var Camera: Camera2D = get_node("Camera2D")
@onready var LevelContainer: Node2D = get_node("Level")
@onready var BodyContainer: Node2D = get_node("DeadBodies")

var Levels := {
	&"Level 1": preload("res://Haven-Jam-Jam/Scenes/Levels/Level1.tscn") as PackedScene,
	&"Level 2": preload("res://Haven-Jam-Jam/Scenes/Levels/Level2.tscn") as PackedScene,
	&"Level End": preload("res://Haven-Jam-Jam/Scenes/Levels/LevelEnd.tscn") as PackedScene,
}

var LevelName: StringName

func QueueFreeChildren(Parent: Node) -> void:
	for i in Parent.get_children():
		i.queue_free()

func EndLevel(Next: StringName) -> void:
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
	if get_node("Level/"+LevelName+"/Level End"):
		get_node("Level/"+LevelName+"/Level End").EndReached.disconnect(EndLevel)
	LevelName = Name
	QueueFreeChildren(LevelContainer)
	QueueFreeChildren(BodyContainer)
	var NewLevel = Levels[Name].instantiate()
	LevelContainer.add_child(NewLevel)
	if get_node("Level/"+LevelName+"/Player Spawn"):
		Player.global_position = get_node("Level/"+LevelName+"/Player Spawn").global_position
		Player.RespawnPoint = Player.global_position
		Camera.global_position = Player.global_position
	if get_node("Level/"+LevelName+"/Level End"):
		get_node("Level/"+LevelName+"/Level End").EndReached.connect(EndLevel)

func _ready() -> void:
	Player.Died.connect(DeathSignal)
	SetupLevel(&"Level 1")
