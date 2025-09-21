extends Node2D

class_name Main

@onready var score_label: Label = $ScoreLabel
static  var _instance: Main = null

func _ready():
	_instance = self if _instance == null else _instance
	score_label.visible = true

static func update_score_label(score: int):
	_instance.score_label.text = "💰" + str(score)
