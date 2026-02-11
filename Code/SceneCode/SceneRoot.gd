extends Node

var AppId = "4416590"
var boardHandle :int
@export var selectedLeaderboard = "Tutorial Fastest Time"
@onready var victoryscreenleaderboard = $PauseableNode/Player/Victory/Panel/ItemList

var updateindex = {}  # Maps steam_id to int
func _init() -> void:
	OS.set_environment("SteamAppID",AppId)
	OS.set_environment("SteamGameID",AppId)
	
	Steam.leaderboard_find_result.connect(leaderboard_result)
	Steam.leaderboard_scores_downloaded.connect(leaderboard_scores)
	Steam.leaderboard_score_uploaded.connect(_on_leaderboard_score_uploaded)
	Steam.avatar_loaded.connect(_on_loaded_avatar)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Steam.steamInit()
	var isRunning = Steam.isSteamRunning()
	
	if !isRunning:
		print("Error Steams Not Running")
	else:
		print("steams good")
		
	#var id = Steam.getSteamID()
	#var name = Steam.getFriendPersonaName(id)
	
	Steam.findLeaderboard(selectedLeaderboard)
	pass # Replace with function body.

func uploadscore(score):
	print("uploadscore called!")
	Steam.uploadLeaderboardScore(score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	Steam.run_callbacks()
	pass
	
func leaderboard_result(handle, found):
	if found:
		boardHandle = handle
		print("leaderboard found")
	else:
		print("leaderboard not found")
		return
	pass

func _on_loaded_avatar(user_id: int, avatar_size: int, avatar_buffer: PackedByteArray) -> void:
	print("Avatar for user: %s" % user_id)
	print("Size: %s" % avatar_size)

	# Create the image and texture for loading
	var avatar_image: Image = Image.create_from_data(avatar_size, avatar_size, false, Image.FORMAT_RGBA8, avatar_buffer)

	# Optionally resize the image if it is too large
	if avatar_size > 128:
		avatar_image.resize(128, 128, Image.INTERPOLATE_LANCZOS)

	# Apply the image to a texture
	var avatar_texture: ImageTexture = ImageTexture.create_from_image(avatar_image)

	victoryscreenleaderboard.set_item_icon(updateindex[user_id],avatar_texture)

func leaderboard_scores(_message, _handle, result):
		print("scorecalled")
		var index = 0
		for r in result:
			var steam_id = r["steam_id"]
			var username = Steam.getFriendPersonaName(steam_id)
			var score = r["score"]
			
			var miliseconds = 0
			var seconds = 0
			var minutes = 0
			var hours = 0
	
			hours = floori(score/3600000)
			score %= 3600000
			minutes = floori(score/60000)
			score %= 60000
			seconds = floori(score / 1000)
			miliseconds = score % 1000
			var compiledtime = 0
			if(hours > 0):
				compiledtime = "%02.0f" % hours + ":" + "%02.0f" % minutes + ":" + "%02.0f" % seconds + ":" + "%003.0f" % miliseconds
			else: 
				compiledtime = "%02.0f" % minutes + ":" + "%02.0f" % seconds + ":" + "%003.0f" % miliseconds
			if victoryscreenleaderboard != null:
				updateindex[steam_id] = index
				Steam.getPlayerAvatar(1,steam_id)
				victoryscreenleaderboard.add_item("  "+username+"  "+compiledtime, null,false)
				index += 1

func _on_leaderboard_score_uploaded(_success,this_handle,_this_score):
	print("scoreupload")
	Steam.downloadLeaderboardEntries(1, 10, Steam.LEADERBOARD_DATA_REQUEST_FRIENDS,this_handle)
	pass
