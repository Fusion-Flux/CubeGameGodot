extends Node

var AppId = "4416590"
var boardHandle :int
@export var selectedLeaderboard = "Tutorial Fastest Time"

func _init() -> void:
	OS.set_environment("SteamAppID",AppId)
	OS.set_environment("SteamGameID",AppId)
	
	Steam.leaderboard_find_result.connect(leaderboard_result)
	Steam.leaderboard_scores_downloaded.connect(leaderboard_scores)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Steam.steamInit()
	var isRunning = Steam.isSteamRunning()
	
	if !isRunning:
		print("Error Steams Not Running")
	else:
		print("steams good")
		
	var id = Steam.getSteamID()
	print(id)
	var name = Steam.getFriendPersonaName(id)
	print(name)
	
	Steam.findLeaderboard(selectedLeaderboard)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	Steam.run_callbacks()
	pass
	
func leaderboard_result(handle, found):
	if found:
		boardHandle = handle
		Steam.downloadLeaderboardEntries(1, 10, Steam.LEADERBOARD_DATA_REQUEST_FRIENDS)
		print("leaderboard found")
	else:
		print("leaderboard not found")
		return
	pass

func leaderboard_scores(message, handle, result):
		for r in result:
			var username = Steam.getFriendPersonaName(r["steam_id"])
			var score = r["score"]
			print(username," ",score)
