extends Control

const LIST_ITEM_SCENE = preload("res://Prefabs/UIScreens/CoolLists/list_item_scene.tscn")
@onready var cool_list_v_box: VBoxContainer = $HBoxContainer/ScrollContainer/CoolListVBox
var imagelist = {}

func _ready() -> void:
	
	for i in cool_list_v_box.get_children():
		i.queue_free()
	

func set_image (index, image):
	print(image)
	imagelist[index].set_list_image(image)

func add_item (username,score,background,index):
	var new_list_item:CoolListItem = LIST_ITEM_SCENE.instantiate()
	#new_list_item.bg_color = "white"
	imagelist[index] = new_list_item
	new_list_item.title = username
	new_list_item.detail = score
	new_list_item.score_background = background
	cool_list_v_box.add_child(new_list_item)
	pass
