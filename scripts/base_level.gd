extends Node
class_name BaseLevel

@export var level_number: int = 1
@export var time_limit: float = 60.0
@onready var win_area: Area2D
@onready var level_timer: Timer

var game_over: bool = false
var player: Player = null
