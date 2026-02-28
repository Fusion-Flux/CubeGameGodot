extends Control


@onready var MainMenu = $"../Main Menu"

var core_array: Array[Node3D] = [null]
var outline_array: Array[Node3D] = [null]
var decor_array: Array[Node3D] = [null]

var enabled_decor: Array[int] = []

@onready var CoreCatagory = $SubViewportContainer/SubViewport/Customization/Cores

@onready var ShownOutline = outline_array[0]
@onready var ShownCore = core_array[0]
@onready var ShownDecor = decor_array[0]

@onready var outline_list = $OutlineList
@onready var core_list = $CoreList
@onready var decor_list = $DecorList
@onready var customization = $SubViewportContainer/SubViewport/Customization
#var outline_index = SaveLoad.SaveFileData.outline_index
#var core_index = SaveLoad.SaveFileData.core_index
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	core_array = customization.get_cores()
	outline_array = customization.get_outlines()
	decor_array = customization.get_decor()
	
	outline_list.clear()
	for outline in outline_array:
		outline_list.add_item(outline.name)
		ShownOutline = outline_array[0]
		
	core_list.clear()
	for core in core_array:
		core_list.add_item(core.name)
		ShownCore = core_array[0]
		
	decor_list.clear()
	for decor in decor_array:
		decor_list.add_item(decor.name)
		ShownDecor = decor_array[0]
	
	
	_on_core_list_item_selected(SaveLoad.SaveFileData.core_index)
	_on_outline_list_item_selected(SaveLoad.SaveFileData.outline_index)
	_on_decor_list_item_selected(SaveLoad.SaveFileData.decor_index)
	
	outline_list.select(SaveLoad.SaveFileData.outline_index, true)
	core_list.select(SaveLoad.SaveFileData.core_index, true)
	decor_list.select(SaveLoad.SaveFileData.decor_index, true)
	pass # Replace with function body.


func _showma() -> void:
	show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func _on_core_list_item_selected(index: int) -> void:
	#core_index = index
	SaveLoad.SaveFileData.core_index = index
	if ShownCore != null:
		ShownCore.hide()
		ShownCore = core_array[index]
		core_array[index].show()
	
	SaveLoad._save()
	pass # Replace with function body.

func _on_outline_list_item_selected(index: int) -> void:
	#outline_index = index
	SaveLoad.SaveFileData.outline_index = index
	
	if ShownOutline != null:
		ShownOutline.hide()
		ShownOutline = outline_array[index]
		outline_array[index].show()
	
	SaveLoad._save()
	pass # Replace with function body.

func _on_decor_list_item_selected(index: int) -> void:
	#outline_index = index
	SaveLoad.SaveFileData.decor_index = index
	if ShownDecor != null:
		ShownDecor.hide()
		ShownDecor = decor_array[index]
		decor_array[index].show()
	
	SaveLoad._save()
	pass # Replace with function body.

func _on_return_from_appearence_pressed() -> void:
	hide()
	MainMenu.show()
	pass # Replace with function body.


func _on_check_button_toggled(toggled_on: bool) -> void:
	SaveLoad.SaveFileData.core_shown = toggled_on
	SaveLoad._save()
	if(CoreCatagory != null):
		CoreCatagory.visible = toggled_on
	pass # Replace with function body.
