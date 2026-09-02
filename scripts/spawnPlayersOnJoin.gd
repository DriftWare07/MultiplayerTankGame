extends Node


const PLAYER = preload("res://scenes/player.tscn")

@export var redspawn : Node2D
@export var bluespawn : Node2D

var players: Array[Entity]
var redTeamPlayers : Array[Entity]
var blueTeamPlayers : Array[Entity]

signal joined_lobby
signal created_lobby

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Networking.host_created.connect(on_host_created)


func on_host_created():
	spawn_player(multiplayer.get_unique_id())
	multiplayer.peer_connected.connect(spawn_player)
	created_lobby.emit()

func spawn_player(peer_id: int):
	var new_player = PLAYER.instantiate()
	new_player.name = str(peer_id)
	add_child(new_player)
	#new_player.position = spawn.position
	initialize_player(new_player)

func initialize_player(player: Entity):
	
	
	if blueTeamPlayers.size() <= redTeamPlayers.size():
		blueTeamPlayers.append(player)
		player.position = bluespawn.position
		player.team = "blue"
	elif redTeamPlayers.size() < redTeamPlayers.size():
		redTeamPlayers.append(player)
		player.position = redspawn.position
		player.team = "red"
	
	players.append(player)


func host_new_lobby() -> void:
	Networking.host_lobby()

func _on_object_spawned(node: Node):
	#check if the thing added is a player, then add said player to array
	if node is CharacterBody2D:
		initialize_player(node)

func quit_game():
	
	get_tree().quit()
