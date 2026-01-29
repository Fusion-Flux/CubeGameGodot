extends Node

var AppId = "480"

func _init() -> void:
	OS.set_environment("SteamAppID",AppId)
	OS.set_environment("SteamGameID",AppId)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Steam.steamInit()
	var isRunning = Steam.isSteamRunning()
	
	if !isRunning:
		print("Error Steams Not Running")
	else:
		print("steams good")
		
	var id = Steam.getSteamID()
	var name = Steam.getFriendPersonaName(id)
	print("Username: ", str(name))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
