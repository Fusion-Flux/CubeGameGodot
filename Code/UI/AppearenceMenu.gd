extends Control


@onready var MainMenu = $"../Main Menu"
@onready var Rainbow = $SubViewportContainer/SubViewport/Customization/Outlines/Rainbow
@onready var Trans = $SubViewportContainer/SubViewport/Customization/Outlines/Trans
@onready var Bi = $SubViewportContainer/SubViewport/Customization/Outlines/Bi
@onready var Space = $SubViewportContainer/SubViewport/Customization/Outlines/Space
@onready var Davekat = $SubViewportContainer/SubViewport/Customization/Outlines/Davekat

@onready var CoreCatagory = $SubViewportContainer/SubViewport/Customization/Cores

@onready var BlackCore = $SubViewportContainer/SubViewport/Customization/Cores/BlackCore
@onready var EarthCore = $SubViewportContainer/SubViewport/Customization/Cores/EarthCore
@onready var HeartCore = $SubViewportContainer/SubViewport/Customization/Cores/HeartCore

@onready var ShownOutline = Rainbow
@onready var ShownCore = BlackCore


#var outline_index = SaveLoad.SaveFileData.outline_index
#var core_index = SaveLoad.SaveFileData.core_index
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_core_list_item_selected(SaveLoad.SaveFileData.core_index)
	_on_outline_list_item_selected(SaveLoad.SaveFileData.outline_index)
	pass # Replace with function body.


func _showma() -> void:
	show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func _on_core_list_item_selected(index: int) -> void:
	#core_index = index
	SaveLoad.SaveFileData.core_index = index
	SaveLoad._save()
	match index:
		0:
			ShownCore.hide()
			ShownCore = BlackCore
			BlackCore.show()
		1:
			ShownCore.hide()
			ShownCore = HeartCore
			HeartCore.show()
		2:
			ShownCore.hide()
			ShownCore = EarthCore
			EarthCore.show()
		_:
			pass
	pass # Replace with function body.

func _on_outline_list_item_selected(index: int) -> void:
	#outline_index = index
	SaveLoad.SaveFileData.outline_index = index
	SaveLoad._save()
	match index:
		0:
			ShownOutline.hide()
			ShownOutline = Rainbow
			Rainbow.show()
		1:
			ShownOutline.hide()
			ShownOutline = Bi
			Bi.show()
		2:
			ShownOutline.hide()
			ShownOutline = Trans
			Trans.show()
		3:
			ShownOutline.hide()
			ShownOutline = Davekat
			Davekat.show()
		4:
			ShownOutline.hide()
			ShownOutline = Space
			Space.show()
		_:
			pass
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
