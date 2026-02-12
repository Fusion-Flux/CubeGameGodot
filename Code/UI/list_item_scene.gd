extends Control
class_name CoolListItem

#@onready var background_color_rect: ColorRect = $BackgroundColorRect
@onready var image_label: Sprite2D = $MarginContainer/HBoxContainer/Sprite2D
@onready var title_label: Label = $MarginContainer/HBoxContainer/TitleLabel
@onready var detail_label: Label = $MarginContainer/HBoxContainer/DetailLabel
@onready var score_background_label: Label = $MarginContainer/HBoxContainer/DetailLabel/ScoreBackgroundLabel

#@export var bg_color:Color
@export var image:Sprite2D
@export var title:String
@export var detail:String
@export var score_background:String

func set_list_image(image):
	image_label.texture = image

func _ready() -> void:
	#background_color_rect.color = bg_color
	#image_label = image
	title_label.text = title
	detail_label.text = detail
	score_background_label.text = score_background
